class Spinnaker # :nodoc:
  # Helper methods for the models
  module Helper
    def self.latest(timeframe)
      vs = Visit.where("timestamp > ?", period(timeframe))
      pages = []
      vs.each do |v|
        pages << Page.find(v.page_id)
      end

      pages.uniq
    end

    def self.period(timeframe)
      case timeframe
      when :today then Date.today.beginning_of_day
      when :this_week then Date.today.beginning_of_week - 1.day
      when :this_month then Date.today.beginning_of_month
      else (Time.now - 1.day).beginning_of_hour
      end
    end
  end
end
