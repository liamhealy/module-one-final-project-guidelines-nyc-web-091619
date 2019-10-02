class CliApp

    def run
        system "clear"
        welcome_message
        if traveler_or_airline == "Traveler"
            traveler = get_traveler
            set_current_traveler(traveler)
            traveler_menu
        else
        end traveler_or_airline == ""
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
        
        if Flight.where(destination: destination).count > 0
            flight = prompt.select("Select the flight you would like to buy a ticket for:", Flight.where(destination: destination))
            # binding.pry
            Ticket.create(traveler_id: @current_traveler.id, flight_id: flight.id)
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
    
    def enter_admin_password
        prompt = TTY::Prompt.new 
        password =  prompt.mask("Please Enter Your Admin Password:")
        if password == "password"
            admin_menu
        else
            puts "Incorrect Password. Abort!"
            run
        end
    end 

    def admin_menu

       


    

end #end of CliApp