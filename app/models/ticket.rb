class Ticket < ActiveRecord::Base
    belongs_to :traveler
    belongs_to :flight
end
