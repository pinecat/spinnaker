# frozen_string_literal: true

class Spinnaker # :nodoc:
  # Model to access data from the 'spinnaker_pages' table.
  class Page < ActiveRecord::Base
    #
    # Database info]
    #
    self.table_name = PAGES_TABLE
    self.primary_key = "id"

    #
    # Relationships
    #

    # Visits track the specific time the page was requested.
    has_many :visits

    #
    # Aliases
    #

    # Needed for the relation with visits to work properly.
    alias_attribute :page_id, :id

    #
    # Functions
    #

    # Get when the last visit to the page was.
    def last_visit
      visits.last.timestamp.localtime.to_s
    end

    # Get visits for a specified timeframe:
    #   :the_last_24_hours
    #   :today
    #   :this_week
    #   :this_month
    #   :this_year
    def visits_for(timeframe)
      visits.where("timestamp > ?", Helper.period(timeframe)).count
    end

    # Override the default as_json method.
    def as_json(*options)
      {
        path: path,
        title: title,
        meta: meta,
        exists: exists,
        visits: visits_for(options[0]),
        last: last_visit
      }
    end
  end
end
