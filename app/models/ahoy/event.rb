module Ahoy
  class Event < ActiveRecord::Base
    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :url

    serialize :properties, JSON

    def track_this_visit

    end
    
  end
end
