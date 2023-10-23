# frozen_string_literal: true

require "active_record"
require "json"
require "nokogiri"
require "rack"
require "yaml"

require_relative "spinnaker/api"
require_relative "spinnaker/migrate"
require_relative "spinnaker/models/helper"
require_relative "spinnaker/models/page"
require_relative "spinnaker/models/visit"
require_relative "spinnaker/version"

# Spinnaker is a rack middleware used to log page hits to a SQL database.
class Spinnaker
  # Error template.
  class Error < StandardError; end

  # return [String] CIDR range to listen on for the API, default is ['127.0.0.1'].
  @@listen = [IPAddr.new("127.0.0.1")]

  # return [String] Endpoint for the API, default is 'spinnaker'.
  @@endpoint = "spinnaker"

  def initialize(app = nil)
    database
    @api = API.new
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    req = Rack::Request.new(env)

    if req.path.start_with? "/#{@@endpoint}"
      return [403, {}, ["Forbidden"]] unless its_from_a_valid_ip(req.ip)

      return @api.handle(req.path.delete_prefix("/#{@@endpoint}").delete_prefix("/"))
    end

    record(req.path, status, body)
    [status, headers, body]
  end

  def listen=(val)
    @@listen.clear
    if val.instance_of?(Array)
      val.each do |v|
        @@listen << IPAddr.new(v)
      end
    else
      @@listen << IPAddr.new(val)
    end
  end

  def endpoint=(val)
    @@endpoint = val
  end

  private

  def database
    conn = ENV.fetch("DATABASE_URL", { adapter: "sqlite3", database: "db/test.db" })
    ActiveRecord::Base.establish_connection(conn)
    SpinnakerMigrations.migrate(:create_pages) unless ActiveRecord::Base.connection.table_exists? PAGES_TABLE
    SpinnakerMigrations.migrate(:create_visits) unless ActiveRecord::Base.connection.table_exists? VISITS_TABLE
  end

  def its_from_a_valid_ip(ip)
    @@listen.each do |addr|
      return true if addr.include? IPAddr.new(ip)
    end

    false
  end

  def record(path, status, body)
    # Check if the page exists
    exists = (status >= 400 && status < 500 ? false : true)

    # Create an entry in the database
    page = Page.find_or_create_by!(path: path)
    page.update!(title: Nokogiri::HTML(body[0]).xpath("//title")&.text, exists: exists)
    Visit.create(page: page, timestamp: Time.now)

    # Determine if there is any meta data to add for the page
    metainfo(page, path)
  end

  def metainfo(page, path)
    meta = nil
    if ["/", ""].include?(path)
      meta = "Index"
    elsif path.include?(".xml") || path.include?(".atom")
      meta = "Feed"
    end

    page.update!(meta: meta)
  end
end
