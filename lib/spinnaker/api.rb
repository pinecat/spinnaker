# frozen_string_literal: true

class Time
  def the_last_24_hours
    (Time.now - 1.day).beginning_of_hour
  end
end

class Spinnaker
  # API endpoints for querying the page data.
  class API
    # Initializer to setup the the endpoints hash and define routes.
    def initialize
      @endpoints = {}
      routes
    end

    # Called with a paht to retrieve data from one of the routes.
    def handle(endpoint)
      blk = @endpoints[endpoint]
      return [404, {}, ["Not found"]] if blk.nil?

      [200, {}, [blk.call]]
    end

    private

    # Simple DSL to define an API route.
    def route(*eps, &block)
      eps.each do |ep|
        @endpoints[ep] = block
      end
    end

    # Define all API routes here
    def routes
      eps = {
        "" => :the_last_24_hours,
        "today" => :beginning_of_day,
        "week" => :beginning_of_week,
        "month" => :beginning_of_month
      }

      eps.each do |path, timeframe|
        route path do
          period = Time.now.public_send(timeframe)
          {
            visits: Visit.where("timestamp > ?", Helper.period(timeframe)).count,
            pages: Helper.latest(period).as_json(timeframe)
          }.to_json
        end
      end
    end
  end
end
