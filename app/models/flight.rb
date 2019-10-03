
class Flight < ActiveRecord::Base
    has_many :tickets
    has_many :travelers, through: :tickets

    # def self.create
    #     flight = Flight.new(airline: airline,
    #                         model: model, 
    #                         origin: origin,
    #                         destination: destination,
    #                         departure: departure,
    #                         arrival: arrival)
    #     flight.save
    #     flight
    # end




end
