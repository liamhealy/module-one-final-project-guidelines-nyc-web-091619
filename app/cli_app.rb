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
        date = get_date
        destination = choose_destination
        purchase_ticket(date, destination)
    end

    def get_date
        prompt = TTY::Prompt.new
        date = []
        year = prompt.ask("(Date) Please enter a year:")
        date << year
        month = prompt.ask("(Date) Please enter a month:")
        date << month
        day = prompt.ask("(Date) Please enter a day:")
        date << day
        date.join("/")
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
            alert = "Go Back"
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
    def purchase_ticket(date, destination)
        flights_from_api = {}
        prompt = TTY::Prompt.new
        FlightApi.get_flight_by_destination(date, destination)
        # puts FlightApi.all
        find_flight = FlightApi.all.find do |flight|
            flight.destination == destination
        end
        if FlightApi.all.count > 0
            flights_from_api[find_flight] = "Flight id: #{find_flight.id}, Going to: #{find_flight.destination} from #{find_flight.origin} on #{find_flight.departure}"
            flight = prompt.select("Select the flight you would like to buy a ticket for:", flights_from_api[find_flight])
            # binding.pry
            Ticket.create(traveler_id: @current_traveler.id, flight_id: find_flight.id)
        else
            option = "Go Back"
            prompt.select("No Flights from NYC to #{destination}", option)
        end
    end
    
    #(Delete) Removing a ticket the user bought
    def return_ticket
        ticket_hash = {}
        my_tickets = @current_traveler.tickets.map do |ticket|
            flight = ticket.flight
            ticket_hash[ticket] = "Ticket id: #{ticket.id}, Going to: #{flight.destination}"
        end
        prompt = TTY::Prompt.new
        if my_tickets.count > 0
            ticket = prompt.select("Select the ticket you would like to return:", ticket_hash.values)
            Ticket.delete(ticket_hash.key(ticket))
        else
            option = "Go Back"
            prompt.select("You currently do not own any tickets.", option)
        end

    end

    ###------------------- Airport Admin

    def admin_menu
        # enter_admin_password
        system "clear"
        create_pastel("Menu:")
        action = get_admin
        admin_action(action)
    end

    def get_admin
        action = create_select_prompt("Menu Options:", ["View all flights", "View all travelers", "Update Flight Information", "Cancel Flights", "Ban Passengers", "Return Home", "Exit GotFlights"])
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
            update_flights_status
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
            "Traveler Id: #{traveler.id}, Name: #{traveler.name}"
        end
        prompt = TTY::Prompt.new
        if all_travelers.count != 0
            prompt.select("Travelers:", all_travelers)
        end
        travelers = Traveler.all
        puts travelers
    end

    def update_flights_status
        prompt = TTY::Prompt.new
        flight_hash = {}
        Flight.all.each do |flight|
            flight_hash[flight] = "Flight id: #{flight.id}, Going to #{flight.destination} from #{flight.origin} on #{flight.departure}"
        end
        flight = prompt.select("Please Select A Flight to Proceed:", flight_hash.values)
        update = prompt.ask("Status Update:")
        flight_instance = flight_hash.key(flight)
        flight_instance.update(status: update.capitalize)
    end

    def cancel_flights
        prompt = TTY::Prompt.new
        flight_hash = {}
        Flight.all.each do |flight|
            flight_hash[flight] = "Flight id: #{flight.id}, Going to #{flight.destination} from #{flight.origin} on #{flight.departure}"
        end
        cancel = prompt.select("Please Select the Flight to be canceled:", flight_hash.values)
        flight_instance = flight_hash.key(cancel)
        Ticket.all.each do |ticket|
            if ticket.flight_id == flight_instance.id
                ticket.destroy
            end
        end
        flight_instance.delete
    end

    def ban_passengers
        prompt = TTY::Prompt.new
        traveler_hash = {}
        Traveler.all.each do |traveler|
            traveler_hash[traveler] = "Traveler ID: #{traveler.id}, Name: #{traveler.name}"
        end
        ban = prompt.select("Please Select the Passenger to be banned:", traveler_hash.values)
        banned_traveler = traveler_hash.key(ban)
        Ticket.all.each do |ticket|
            if ticket.traveler_id == banned_traveler.id
                ticket.destroy
            end
        end
        banned_traveler.delete
    end

end #end of CliApp