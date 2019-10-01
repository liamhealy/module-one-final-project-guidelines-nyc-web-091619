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
        prompt.select("My Flights:", my_flights)
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
        








end #end of CliApp