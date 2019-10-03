require_relative "../config"
require 'rest-client'
require 'pry'
require 'JSON'

class FlightApi

    @@all = []

    def self.get_flight_by_destination(user_destination)


        puts "Welcome to API practice."
        puts "Here is some flight data from the internet:"

        url = "https://api.flightstats.com/flex/schedules/rest/v1/json/from/JFK/departing/2019/10/5/12?appId=#{ID}&appKey=#{KEY}"

        response = RestClient.get(url)
        response_hash = JSON.parse(response)

        flights = response_hash["scheduledFlights"]

        flights.find do |flight|
            # flightNumber
            # departureAirportFsCode
            # arrivalAirportFsCode
            # departureTime
            # arrivalTime
            # flight_num = flight["flightNumber"]
            origin = flight["departureAirportFsCode"]
            destination = flight["arrivalAirportFsCode"]
            departure_time = flight["departureTime"]
            arrival_time = flight["arrivalTime"]

            if destination == user_destination
                @@all << Flight.create(origin: origin, destination: destination, departure: departure_time, arrival: arrival_time)
            end

            # puts "#{i}. #{flight_num} \n Departs from #{origin} at #{departure_time} \n Arrives at #{destination} at #{arrival_time}"
        end

        
    end
    
    def self.all
        @@all
    end

end # end of api