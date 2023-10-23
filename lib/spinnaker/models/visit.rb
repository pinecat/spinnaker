# frozen_string_literal: true

class Spinnaker # :nodoc:
  # Model to access data from the 'spinnaker_visits' table.
  class Visit < ActiveRecord::Base
    self.table_name = VISITS_TABLE
    self.primary_key = "id"
    belongs_to :page
  end
end
