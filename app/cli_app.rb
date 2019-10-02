class CliApp

    def run
        system "clear"
        welcome_message

        traveler = get_traveler
        set_current_traveler(traveler)
        # binding.pry 
        traveler_menu
        # action = get_action
        # execute_action(action)
    end

    def traveler_menu
        system "clear"
        pastel = Pastel.new
        font = TTY::Font.new
        puts pastel.red(font.write("Menu:"))
        action = get_action
        execute_action(action)
    end

    def welcome_message
        # puts "Welcome"
        pastel = Pastel.new
        font = TTY::Font.new
        puts pastel.red(font.write("GotFlights?"))
        puts "Welcome to Got Flights!"
    end

    # def traveler_or_airline
    #     puts "Are you a traveler or Airline Admin?"
    #     input = gets.chomp
    #     if input == "traveler"
    #         get_traveler
    #     else
    #         get_airline_admin
    #     end
    # end

    # def get_airline_admin
    #     puts "Please Enter Your Airline: "
    #     airline = gets.chomp

    #     Flight.find_or_create_by(airline)
    # end

    def get_traveler
        puts "Please Enter Your Name: "
        name = gets.chomp

        Traveler.find_or_create_by(name: name)
    end

    def set_current_traveler(traveler)
        @current_traveler = traveler
    end

    def get_action
        prompt = TTY::Prompt.new
        all_actions = ["View my flights", "Purchase a flight ticket", "Leave"]
        action = prompt.select("Menu Options:", all_actions)
        return action
    end

    def execute_action(action)
        case action
        when "View my flights"
            list_my_flights
        when "Purchase a flight ticket"
            purchase_ticket
        when "Leave"
            system "clear"
            return
        end
        traveler_menu
    end

    # (Read) List all of the current traveler's flights
    def list_my_flights
        my_flights = @current_traveler.flights.map do |flight|
            # binding.pry
            "- Flight Id: #{flight.id}, Airline: #{flight.airline}, Origin: #{flight.origin}, Destination: #{flight.destination}"
        end
        prompt = TTY::Prompt.new
        if my_flights.count >= 1
            prompt.select("My Flights:", my_flights)
        else
            alert = "You have not purchased any tickets for any flights."
            prompt.select("You have not purchased any tickets for any flights.", alert)
        end
    end

    # (Read) List all of the flights that exist
    def list_all_flights
        flights = Flight.all.map do |flight|
            # binding.pry
            # "- Flight Id: #{flight.id}, Airline: #{flight.airline}, Origin: #{flight.origin}, Destination: #{flight.destination}"
            flight
        end
        flights
    end

    # (Create) Buy a ticket for any flight
    def purchase_ticket
        prompt = TTY::Prompt.new
        flight = prompt.select("Select the flight you would like to buy a ticket for:", list_all_flights)
        # binding.pry
        Ticket.create(traveler_id: @current_traveler.id, flight_id: flight.id)
    end
        
    # def set_current_airline(airline)
    #     @current_airline = airline
    # end

    # def get_traveler_destination
    #     puts "Where is you going?"
    #     travel_destination = gets.chomp

    #     Traveler.destination = travel_destination
    # end

    # def view_origin(origin = "NYC")
    #     Traveler.origin
    # end
    
    # def update_destination
    #     puts "Where is you going NOW?"
    #     new_destination = gets.chomp

    #     Traveler.destination = new_destination
    # end

    # def cancel_trip_to
    #     puts "Please Enter Destination to Cancel: "
    #     cancel_destination = gets.chomp

    #     Traveler.destination.find_by(cancel_destination).delete

    # end






end #end of CliApp