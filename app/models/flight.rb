
class Flight < ActiveRecord::Base
    has_many :tickets
    has_many :travelers, through: :tickets
end
