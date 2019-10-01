class CliApp





    def run
        welcome_message
        
        traveler = get_traveler
        set_current_traveler(traveler)
        # binding.pry
    end

    def welcome_message
        puts "Welcome"
    end

    def get_traveler
        puts "Please Enter Your Name: "
        name = gets.chomp

        Traveler.find_or_create_by(name: name)
    end

    def set_current_traveler(traveler)
        @current_traveler = traveler
    end









end #end of CliApp