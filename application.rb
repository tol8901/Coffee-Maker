module Application
  def self.run
    coffee_maker = CoffeeMachine.new
    begin
      puts " Coffee-Maker Application ".center(50, '#')
      puts "a) Switch On Machine"
      puts "b) Switch Off Machine"
      puts "c) Make Coffee"
      puts "q) Switch Off the machine and quit"
      print "Select a menu item, please: "
      choice = gets.chomp.downcase

      # Validation of user input
      unless choice.gsub(/[a-c,q]/, '').empty?
        puts "Invalid input! Select one of the items in the menu, please."
        puts ""
      end

      case choice[0]
      when 'a' then coffee_maker.switch_on
      when 'b' then coffee_maker.switch_off
      when 'c' then coffee_maker.next_cup
      end
    end while choice != 'q'
  end

  class CoffeeMaker
    def initialize
      @is_turned_on = false # the state of the machine (On/Off)
      @is_ready = false # the state of machine when it is ready to make a drink
      @action = "" # required action to pass self-check

      # amount of water in water tank (0..2 liters)
      @min_water_tank_amount = 0 # liters
      @max_water_tank_amount = 2.0 # liters

      # amount of space in trash can (0..2 kg)
      @min_trash_can_amount = 0 # kilograms
      @max_trash_can_amount = 2.0 # kilograms

      # A can for fresh beans (0..1 kg)
      @min_beans_can_amount = 0 # kilograms
      @max_beans_can_amount = 1 # kilograms
    end

    def switch_on
      @water_tank = 0 if @water_tank.nil?
      @trash_can = 0 if @trash_can.nil?
      @beans_can = 0 if @beans_can.nil?

      # Check state of the machine
      if @is_turned_on # Turning on already working machine
        return puts "The machine is already turned on"
      else
        @is_turned_on = true
      end

      # Turning on the machine procedure
      puts "Loading".ljust(50, ".")
      sleep 2
      puts "Self-check in progress".ljust(50, ".")

      if self_check # the system is ready to work
        select_drink
        make_coffee
      end
    end

    def switch_off
      # Check the state of the machine (ON/OFF)
      if @is_turned_on # Turning off already not working machine
        @is_turned_on = false
      else
        return puts "The machine is already turned off"
      end

      # Turning off the machine procedure
      puts "Shutting down".ljust(50, ".")
      sleep 2
      puts "Goodbye :-)".rjust(50, ".")
      puts "Press 'q' to quit"
    end

    def next_cup
      @water_tank = 0 if @water_tank.nil?
      @trash_can = 0 if @trash_can.nil?
      @beans_can = 0 if @beans_can.nil?


      # Check state of the machine (ON/OFF)
      if @is_turned_on # The machine is turned on
        user_select_drink
      else # The machine is turned off
        puts " First of all, Switch On the Machine ".center(50, "!")
      end

      self_check
    end

    private

    # Self-check sequence
    def self_check
      if check_beans_level || check_trash_level || check_water_level
        true
      end
    end

    def check_water_level
      # Checking a water tank state procedure
      if @water_tank <= @min_water_tank_amount
        @is_ready = false
        puts "Fill a water tank, please".center(50, '!')
        print "Enter amount of water, please (0 - 2 liters): "
        @water_tank = gets.chomp.to_f
        puts "In water tank is present: #{@water_tank} l"
        check_water_level # Repeat checking procedure
      elsif @water_tank > @max_water_tank_amount
        @is_ready = false
        puts  "Too much water in the water tank! Fill less, please!"
        print "Enter amount of water to drain (liters): "
        drained_water = gets.chomp.to_f.round(2)
        @water_tank -= drained_water
        puts "In water tank is present: #{@water_tank.round(2)} l"
        check_water_level # Repeat checking procedure
      elsif @water_tank <= @max_water_tank_amount && @water_tank > @min_water_tank_amount
        puts "Water Tank - OK".rjust(50, '.')
        @is_ready = true
        return @is_ready
      end
    end

    def check_trash_level
      # Check trash can procedure
      if @trash_can >= @max_trash_can_amount # The trash can is full - need to clean
        puts "Clean the trash can, please!".center(50, '!')
        print "Are you already empty the trash can? (Y/N): "
        user_cleaned = gets.chomp.downcase
        case user_cleaned
        when 'y' then @trash_can = 0
        when 'n' then puts "You cannot continue. Clean it, please!".center(50, '!')
        end
        check_trash_level
      elsif @trash_can >= @min_trash_can_amount # The trash can is empty
        puts "Trash Can - OK".rjust(50, '.')
      elsif @trash_can < @min_trash_can_amount
        @trash_can = 0
      end
    end

    def check_beans_level
      if @beans_can <= @min_beans_can_amount
        puts "A Beans Can is empty! Fill it, please!".center(50, '!')
        print "Fill the Can, please (0 - 1 kilograms): "
        user_filed_beans = gets.chomp.downcase.to_f
        @beans_can += user_filed_beans
        puts "Current amount of beans is #{@beans_can.round(2)} kg."
        check_beans_level
      elsif @beans_can > @max_beans_can_amount
        puts "Too much of beans in the Beans Can!".center(50, '!')
        print "How much beans do you want to remove (kg)? "
        beans_removed = gets.chomp.to_f.round(2)
        @beans_can -= beans_removed
        puts "Current amount of beans is #{@beans_can.round(2)} kg."
        check_beans_level
      elsif @beans_can > @min_beans_can_amount && @beans_can <= @max_beans_can_amount
        puts "Beans Can - OK".rjust(50, '.')
      end
    end

    def user_select_drink
        select_drink
        make_coffee
    end

    # Procedure of selecting a drink by user
    def select_drink
      begin
        @chosen_drink = ""
        puts "Available drinks:"
        puts "a) Americano"
        puts "b) Espresso"
        puts "c) Double Americano"
        puts "d) Double Espresso"
        puts "q) Exit"
        print "Select your drink, please: "
        selected_drink = gets.chomp.downcase

        # Validation of the user input
        unless selected_drink.gsub(/[a-d,q]/, '').empty?
          puts "Invalid input! Select one of the items in the menu, please."
        end

        case selected_drink[0]
        when 'a' then return @chosen_drink = "Americano"
        when 'b' then return @chosen_drink = "Espresso"
        when 'c' then return @chosen_drink = "Double Americano"
        when 'd' then return @chosen_drink = "Double Espresso"
        when 'q' then return @chosen_drink = "q"
        end

      end while selected_drink != 'q'
    end

    # Making coffee procedure
    def make_coffee
      if @chosen_drink != 'q' # switch_on procedure was successful
        puts "Preparing a drink: #{@chosen_drink} (200ml)".ljust(50, ".")
        # Inform user about status of coffee preparing;
        puts "Heating of water".ljust(50, '.')
        sleep 2
        puts "Done".rjust(50, '.')
        puts "Grinding of beans".ljust(50, '.')
        sleep 2
        puts "Done".rjust(50, '.')
        puts "Flowing of water through grinded coffee beans".ljust(50, '.')
        sleep 3
        puts "Your coffee is ready! Take your cup, please.".rjust(50, ".")
        puts ""
        @water_tank -= 0.2 # water consumption per cup of coffee
        @trash_can += 1 # trash generation from one cup of coffee
        @beans_can -= 0.5 # beans consumption per one cup of cofee
      elsif @chosen_drink == 'q'
        puts ""
      end
    end
  end

  class CoffeeMachine < CoffeeMaker
    def initialize
      @is_turned_on = false # the state of the machine (On/Off)
      @is_ready = false # the state of machine when it is ready to make a drink
      @action = "" # required action to pass self-check

      # amount of water in water tank (0..2 liters)
      @min_water_tank_amount = 0 # liters
      @max_water_tank_amount = 2.0 # liters

      # amount of space in trash can (0..2 kg)
      @min_trash_can_amount = 0 # kilograms
      @max_trash_can_amount = 2.0 # kilograms

      # A can for fresh beans (0..1 kg)
      @min_beans_can_amount = 0 # kilograms
      @max_beans_can_amount = 1 # kilograms
    end

    def select_drink
      begin
        @chosen_drink = ""
        puts "Available drinks:"
        puts "a) Americano"
        puts "b) Espresso"
        puts "c) Double Americano"
        puts "d) Double Espresso"
        puts "e) Latte"
        puts "f) Cappuccino"
        puts "q) Exit"
        print "Select your drink, please: "
        selected_drink = gets.chomp.downcase

        # Validation of the user input
        unless selected_drink.gsub(/[a-f,q]/, '').empty?
          puts "Invalid input! Select one of the items in the menu, please."
        end

        case selected_drink[0]
        when 'a' then return @chosen_drink = "Americano"
        when 'b' then return @chosen_drink = "Espresso"
        when 'c' then return @chosen_drink = "Double Americano"
        when 'd' then return @chosen_drink = "Double Espresso"
        when 'e' then return @chosen_drink = "Latte"
        when 'f' then return @chosen_drink = "Cappuccino"
        when 'q' then return @chosen_drink = "q"
        end
      end while selected_drink != 'q'
    end

  end
end