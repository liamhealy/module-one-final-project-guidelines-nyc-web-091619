class CliApp

    def run
        system "clear"
        welcome_message
        traveler_or_airline
        traveler = get_traveler
        set_current_traveler(traveler)
        # binding.pry 
        traveler_menu
        # action = get_action
        # execute_action(action)
    end

    def update_traveler
        traveler = Traveler.find_or_create_by(name: @current_traveler.name)
        @current_traveler = traveler
    end

    def traveler_menu
        update_traveler
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


    
    def traveler_or_airline
        prompt = TTY::Prompt.new
        both_interface = ["Traveler", "Airline"]
        choose = prompt.select("Sign-in As:", both_interface)
        return choose
    end

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
        all_actions = ["View my flights", "Purchase a flight ticket", "Return a ticket", "Leave"]
        action = prompt.select("Menu Options:", all_actions)
        return action
    end

    def execute_action(action)
        case action
        when "View my flights"
            list_my_flights
        when "Purchase a flight ticket"

            # purchase_ticket
            purchase_menu
        when "Return a ticket"
            return_ticket
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
        if my_flights.count > 0 
            prompt.select("My Flights:", my_flights)
        else
            alert = "You have not purchased any tickets for any flights."
            prompt.select("You have not purchased any tickets for any flights.", alert)
        end
    end

    # (Read) List all of the flights in existence
    def list_all_flights
        flights = Flight.all.map do |flight|
            # binding.pry
            # "- Flight Id: #{flight.id}, Airline: #{flight.airline}, Origin: #{flight.origin}, Destination: #{flight.destination}"
            flight
        end
        flights
    end

    # (Create) Buy a ticket for any flight
    def purchase_ticket(destination)
        prompt = TTY::Prompt.new

        if Flight.where(destination: destination).count > 0
            flight = prompt.select("Select the flight you would like to buy a ticket for:", Flight.where(destination: destination))
            # binding.pry
            Ticket.create(traveler_id: @current_traveler.id, flight_id: flight.id)
        else
            option = "Go Back"
            prompt.select("No Flights from NYC to #{destination}", option)
        end
        
    end
        
    def purchase_menu
        airport = choose_origin
        destination = choose_destination
        purchase_ticket(destination)
    end

    def choose_origin
        prompt = TTY::Prompt.new
        airport = prompt.select("Please Choose Your Departing Airport:", %w(JFK Laguardia))
    end

    def choose_destination
        prompt = TTY::Prompt.new
        destination = prompt.ask("Please Choose Your Desired Destination:")
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



    
    #(Delete) Removing a ticket the user bought
    def return_ticket
        my_tickets = @current_traveler.flights.map do |flight|
            flight
        end
        prompt = TTY::Prompt.new
        ticket = prompt.select("Select the ticket you would like to return:", @current_traveler.tickets)
        Ticket.delete(ticket)
    end

end #end of CliApp