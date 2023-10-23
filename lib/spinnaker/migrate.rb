# frozen_string_literal: true

class Spinnaker # :nodoc:
  # return [String] The name of the pages table.
  PAGES_TABLE = :spinnaker_pages

  # return [String] The name of the visits table.
  VISITS_TABLE = :spinnaker_visits

  # Migrations for the Spinnaker table, which keeps track of page hits.
  class SpinnakerMigrations < ActiveRecord::Migration[7.1]
    def create_pages
      create_table PAGES_TABLE do |t|
        t.string   :path, default: "", null: false
        t.string   :title, default: nil
        t.string   :meta, default: nil
        t.boolean  :exists, default: false
      end

      add_index PAGES_TABLE, :path
    end

    def create_visits
      create_table VISITS_TABLE do |t|
        t.datetime :timestamp, null: false
      end

      add_reference VISITS_TABLE, :page, null: false, foreign_key: { to_table: PAGES_TABLE }
    end
  end
end
