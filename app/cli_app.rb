require_relative 'flight_api'

class CliApp
    
    def run
        system "clear"
        welcome_message
        if traveler_or_admin == "Traveler"
            traveler = get_traveler
            set_current_traveler(traveler)
            traveler_menu
        else
            enter_admin_password
            admin_menu
        end 
    end
    
    def welcome_message
        create_pastel("GotFlights?")
        puts "Welcome to Got Flights!"
    end


    def create_pastel(message)
        pastel = Pastel.new
        font = TTY::Font.new
        puts pastel.red(font.write(message))
    end

    def create_select_prompt(prompt_message, options)
        prompt = TTY::Prompt.new
        prompt.select(prompt_message, options)
    end

    def traveler_or_admin
        choose = create_select_prompt("Sign-in As:", ["Traveler", "Admin"])
    end

    ### ------------------- Traveler
    
    def update_traveler
        traveler = Traveler.find_or_create_by(name: @current_traveler.name)
        @current_traveler = traveler
    end

    def traveler_menu
        update_traveler
        system "clear"
        create_pastel("Menu:")
        action = get_action
        execute_action(action)
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
        action = create_select_prompt("Menu Options:", ["View my flights", "Purchase a flight ticket", "Return a ticket", "Return Home", "Exit GotFlights"])
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
    
    def execute_action(action)
        case action
        when "View my flights"
            list_my_flights
        when "Purchase a flight ticket"
            purchase_menu
        when "Return a ticket"
            return_ticket
        when "Return Home"
            system "clear"
            run 
        when "Exit GotFlights"
            system "clear"
            exit
        end
        traveler_menu
    end
    
    # (Read) List all of the current traveler's flights
    def list_my_flights
        my_flights = @current_traveler.flights.map do |flight|
            # binding.pry
            "- Flight Id: #{flight.id}, Origin: #{flight.origin}, Destination: #{flight.destination}"
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
    
    # (Create) Buy a ticket for a flight
    def purchase_ticket(destination)
        prompt = TTY::Prompt.new
        FlightApi.get_flight_by_destination(destination)
        puts FlightApi.all
        find_flight = FlightApi.all.find do |flight|
            flight.destination == destination
        end
        
        if FlightApi.all.count > 0
            flight = prompt.select("Select the flight you would like to buy a ticket for:", find_flight)
            # binding.pry
            Ticket.create(traveler_id: @current_traveler.id, flight_id: find_flight.id)
        else
            option = "Go Back"
            prompt.select("No Flights from NYC to #{destination}", option)
        end
        
    end
    
    #(Delete) Removing a ticket the user bought
    def return_ticket
        my_tickets = @current_traveler.flights.map do |ticket|
            ticket
        end
        prompt = TTY::Prompt.new
        if my_tickets.count > 0
            ticket = prompt.select("Select the ticket you would like to return:", @current_traveler.tickets)
            Ticket.delete(ticket)
        else
            option = "Go Back"
            prompt.select("You currently do not own any tickets.", option)
        end

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

    ###------------------- Airport Admin

    def admin_menu
        # enter_admin_password
        system "clear"
        create_pastel("Menu:")
        action = get_admin
        admin_action(action)
    end

    def get_admin
        action = create_select_prompt("Menu Options:", ["View all flights", "View all travelers", "Update Flight Informtion", "Cancel Flights", "Ban Passengers", "Return Home", "Exit GotFlights"])
    end
    
    def enter_admin_password
        prompt = TTY::Prompt.new 
        password =  prompt.mask("Please Enter Your Admin Password:")
        if password == "password"
            admin_menu
        else
            choice = ["Retry", "Exit GotFlights"]
            option = create_select_prompt("Incorrect Password. What Would You Like to Do?", choice)
                if option == "Retry"
                    run
                else
                    exit
                end

        end
    end 



    def admin_action(action)
        # flights = Flight.all
        # puts flights
        case action
        when "View all flights"
            see_all_flights
        when "View all travelers"
            see_all_travelers
        when "Update Flight Information"
            # update_flights
        when "Cancel Flights"
            cancel_flights
        when "Ban Passengers"
            ban_passengers
        when "Return Home"
            system "clear"
            run 
        when "Exit GotFlights"
            system "clear"
            exit
        end
        admin_menu
    end

    def see_all_flights
        all_flights = Flight.all.map do |flight|
            "- Flight Id: #{flight.id}, Origin: #{flight.origin}, Destination: #{flight.destination}"
        end
        prompt = TTY::Prompt.new
        if all_flights.count != 0
            prompt.select("Flights:", all_flights)
        
        end
    end

    def see_all_travelers 
            all_travelers = Traveler.all.map do |traveler|
            "-Traveler Id: #{traveler.id}, Name: #{traveler.name}-"
            end
            prompt = TTY::Prompt.new
            if all_travelers.count != 0
            prompt.select("Travelers:", all_travelers)
            end
        
            travelers = Traveler.all
            puts travelers
    end

    def cancel_flights
        prompt = TTY::Prompt.new
        cancel = prompt.select("Please Select the Flight to be canceled:", Flight.all)
        cancel.delete
    end

    def ban_passengers
        prompt = TTY::Prompt.new
        ban = prompt.select("Please Select the Passenger to be banned:", Traveler.all)
        ban.delete
    end



    

end #end of CliApp