# frozen_string_literal: true

class Spinnaker
  # API endpoints for querying the page data.
  class API
    # Initializer to setup the the endpoints hash and define routes.
    def initialize
      @endpoints = {}
      routes
    end

    # Called with a path to retrieve data from one of the routes.
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
      # /latest, /
      # Default API endpoint, serves metrics for the last 24 hours.
      route "", "latest" do
        period = :the_last_24_hours
        {
          visits: Visit.where("timestamp > ?", Helper.period(period)).count,
          pages: Helper.latest(period)
        }.to_json
      end

      # /today
      # Serves metrics for the current day.
      route "today" do
        period = :today
        {
          visits: Visit.where("timestamp > ?", Helper.period(period)).count,
          pages: Helper.latest(period).as_json(period)
        }.to_json
      end

      # /week
      # Serves metrics for the current week.
      route "week" do
        period = :this_week
        {
          visits: Visit.where("timestamp > ?", Helper.period(period)).count,
          pages: Helper.latest(period).as_json(period)
        }.to_json
      end

      # /month
      # Serves metrics for the current month.
      route "month" do
        period = :this_month
        {
          visits: Visit.where("timestamp > ?", Helper.period(period)).count,
          pages: Helper.latest(period).as_json(period)
        }.to_json
      end
    end
  end
end
