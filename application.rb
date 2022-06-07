module Application
  def self.run
    begin
      puts " Welcome to Coffee-Machine vendor menu ".center(50, '#')
      manufacturers = ["DELONGHI", "PHILIPS", "REDMOND"] # Available manufacturers
      i = 0 # Loop counter - init number of the menu item list (manufacturers)
      qty_of_manufacturers = manufacturers.size # How many manufacturers are available
      manufacturers.each do |manufacturer| # Show a list of available manufacturers
        puts "#{i + 1}) #{manufacturers[i]}"
        i += 1
      end
      puts "s) Skip, leave default (#{manufacturers[0]})"
      print "Select a manufacturer, please: "
      selected_vendor = gets.chomp.downcase

      # Validation of user input
      unless selected_vendor.gsub(/[1-#{qty_of_manufacturers},s]/, '').empty?
        puts "Invalid input! Select one of the items in the menu, please."
        puts ""
      end

      # Factory method
      case selected_vendor[0]
      when '1'
        coffee_maker = Delonghi.new
        break
      when '2'
        coffee_maker = Philips.new
        break
      when '3'
        coffee_maker = Redmond.new
        break
      end
    end while selected_vendor != 's'

    # User selected vendor confirmation
    if selected_vendor == 's' # If user wants to skip and select default manufacturer - select the first one
      coffee_maker = Delonghi.new
      puts "Default vendor is: #{manufacturers[0]}".center(50, '-')
    else
      puts "Your selected vendor: #{manufacturers[selected_vendor[0].to_i - 1]}".center(50, '-')
    end

    # Show the main menu
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
    attr_accessor :state_object
    # Amount of water in a water tank (liters)
    MIN_WATER_TANK_AMOUNT = 0 # liters
    MAX_WATER_TANK_AMOUNT = 2 # liters
    # Amount of space in trash can (kilograms)
    MIN_TRASH_CAN_AMOUNT = 0 # kg
    MAX_TRASH_CAN_AMOUNT = 2 # kg
    # Amount of can for fresh beans (kilograms)
    MIN_BEANS_CAN_AMOUNT = 0 # kg
    MAX_BEANS_CAN_AMOUNT = 1 # kg
    # Time of loading (seconds)
    DELAY_LOADING = 3 # sec

    def initialize
      @is_ready = false # the state of machine when it is ready to make a drink

      # Amount of water in water tank (0..2 liters)
      @min_water_tank_amount = self.class::MIN_WATER_TANK_AMOUNT # liters
      @max_water_tank_amount = self.class::MAX_WATER_TANK_AMOUNT # liters

      # Amount of space in trash can (kilograms)
      @min_trash_can_amount = self.class::MIN_TRASH_CAN_AMOUNT # kg
      @max_trash_can_amount = self.class::MAX_TRASH_CAN_AMOUNT # kg

      # Amount of can for fresh beans (kilograms)
      @min_beans_can_amount = self.class::MIN_BEANS_CAN_AMOUNT # kilograms
      @max_beans_can_amount = self.class::MAX_BEANS_CAN_AMOUNT # kilograms

      # Time of loading
      @loading_delay = self.class::DELAY_LOADING

      # The volume of the cup for drink, ml
      @cup_volume = 200 # ml
      self.state_object = StateMachineOnOff.new
    end

    def switch_on
      @water_tank = 0 if @water_tank.nil?
      @trash_can = 0 if @trash_can.nil?
      @beans_can = 0 if @beans_can.nil?

      # Turning On the machine
      self.state_object.turn_on
    end

    def switch_off
      # Turning Off the machine
      self.state_object.turn_off
    end

    def next_cup
      @water_tank = 0 if @water_tank.nil?
      @trash_can = 0 if @trash_can.nil?
      @beans_can = 0 if @beans_can.nil?

      # Check state of the machine (ON/OFF)
      if self.state_object.is_on? && self_check # The machine is turned on
        user_select_drink
      else # The machine is turned off
        puts " First of all, Switch On the Machine ".center(50, "!")
      end
    end

    private

    # Self-check sequence
    def self_check
      puts "Self-check in progress".ljust(50, ".")
      if check_beans_level || check_trash_level || check_water_level
        true
      end
    end

    def check_water_level
      # Checking a water tank state procedure
      if @water_tank <= @min_water_tank_amount
        @is_ready = false
        puts "Fill a water tank, please".center(50, '!')
        print "Enter amount of water, please (#{@min_water_tank_amount} - #{@max_water_tank_amount} liters): "
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
      # Check Trash Can procedure
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
        print "Fill the Can, please (#{@min_beans_can_amount} - #{@max_beans_can_amount} kilograms): "
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

    def select_drink
      # Available drinks list
      @available_drinks = {
        a: 'Americano',
        b: 'Espresso',
        c: 'Double Americano',
        d: 'Double Espresso',
        e: 'Latte',
        f: 'Cappuccino',
      }

      begin
        @chosen_drink = ""
        puts "Available drinks:"
        @available_drinks.each do |key_drink, name_drink|
          puts "#{key_drink}) #{name_drink}"
        end
        print "Select your drink, please: "
        selected_drink = gets.chomp.downcase

        # Validation of the user input
        unless selected_drink.gsub(/[#{@available_drinks.keys}]/, '').empty?
          puts "Invalid input! Select one of the items in the menu, please."
        end

        @chosen_drink = "#{@available_drinks[selected_drink[0].to_sym]}"
        break if @chosen_drink != ''
      end while selected_drink != 'q'
    end

    def make_coffee
    # Making coffee procedure
      # Add cup
      cup = Cup.new

      if @chosen_drink != 'q' # switch_on procedure was successful
        puts "Preparing a drink: #{@chosen_drink} (#{@cup_volume} ml)".ljust(50, ".")
        # Inform user about status of coffee preparing;
        puts "Heating of water".ljust(50, '.')
        sleep 1
        puts "Done".rjust(50, '.')
        puts "Grinding of beans".ljust(50, '.')
        sleep 1
        puts "Done".rjust(50, '.')
        puts "Flowing of water through grinded coffee beans".ljust(50, '.')
        sleep 1
        cup.is_full = true
        puts "Your coffee is ready! Take your cup, please.".rjust(50, ".")
        puts ""
        @water_tank -= (@cup_volume / 100) # water consumption per cup of coffee
        @trash_can += 1 # trash generation from one cup of coffee
        @beans_can -= 0.5 # beans consumption per one cup of coffee
      elsif @chosen_drink == 'q'
        puts ""
      end
    end
  end

  class Delonghi < CoffeeMaker
    # Amount of water in a water tank (liters)
    MIN_WATER_TANK_AMOUNT = 0 # liters
    MAX_WATER_TANK_AMOUNT = 1.5 # liters
    # Amount of space in trash can (kilograms)
    MIN_TRASH_CAN_AMOUNT = 0 # kg
    MAX_TRASH_CAN_AMOUNT = 2 # kg
    # Amount of can for fresh beans (kilograms)
    MIN_BEANS_CAN_AMOUNT = 0 # kg
    MAX_BEANS_CAN_AMOUNT = 1 # kg
    # Time of loading (seconds)
    DELAY_LOADING = 1 # sec
  end

  class Philips < CoffeeMaker
    # Amount of water in a water tank (liters)
    MIN_WATER_TANK_AMOUNT = 0 # liters
    MAX_WATER_TANK_AMOUNT = 2 # liters
    # Amount of space in trash can (kilograms)
    MIN_TRASH_CAN_AMOUNT = 0 # kg
    MAX_TRASH_CAN_AMOUNT = 3 # kg
    # Amount of can for fresh beans (kilograms)
    MIN_BEANS_CAN_AMOUNT = 0 # kg
    MAX_BEANS_CAN_AMOUNT = 2 # kg
    # Time of loading (seconds)
    DELAY_LOADING = 2 # sec
  end

  class Redmond < CoffeeMaker
    # Amount of water in a water tank (liters)
    MIN_WATER_TANK_AMOUNT = 0 # liters
    MAX_WATER_TANK_AMOUNT = 3 # liters
    # Amount of space in trash can (kilograms)
    MIN_TRASH_CAN_AMOUNT = 0 # kg
    MAX_TRASH_CAN_AMOUNT = 4 # kg
    # Amount of can for fresh beans (kilograms)
    MIN_BEANS_CAN_AMOUNT = 0 # kg
    MAX_BEANS_CAN_AMOUNT = 3 # kg
    # Time of loading (seconds)
    DELAY_LOADING = 3 # sec
  end

  class Cup
    attr_accessor :volume, :is_full
    def initialize
      @is_full = false
      @volume = 0
      @size = 0.2 # liters
    end

    def cup_volume(volume)
      @volume = volume
    end

    def show_cup_volume
      @volume
    end

    def fill_cup(is_full)
      @is_full = is_full
    end
  end

  class StateMachineOnOff
    # This class is about store and change the state of an object
    # States: on, off
    # State events: turn_on, turn_off
    # Transitions: from on to off, from off to on
    def initialize
      @state = 'OFF'
    end

    # Display current state
    def state?
      @state
    end

    # Check the state: is it On?
    def is_on?
      @state == 'ON'
    end

    # Check the state: is it Off?
    def is_off?
      @state == 'OFF'
    end

    # Event: to turn On
    def turn_on
      if is_on? # If the machine is already in On state
        # The state doesn't change, still in On state
        puts "The state is already ON. No state changes".center(50, "!")
      else # If the state is Off
        off_to_on # Run transition from state Off to On
        # Turning on the machine procedure
        puts "Loading".ljust(50, ".")
        sleep 1

      end
    end

    # Event: to turn off
    def turn_off
      if is_off? # If the machine is already in Off state
        # The state doesn't change, still in Off sate
        puts "The state is already OFF. No state changes".center(50, "!")
      else # If the state is On
        on_to_off # Run transition from state On to Off
      end
    end

    # Transition: from Off to On
    def off_to_on
      # State Off -> On
      @state = 'ON'
      puts "Changed state to On".center(50, "~")
    end

    # Transition: from On to Off
    def on_to_off
      # State On -> Off
      @state = 'OFF'
      puts "Changed state to Off".center(50, "~")
      # Turning off the machine procedure
      puts "Shutting down".ljust(50, ".")
      sleep 1
      puts "Goodbye :-)".rjust(50, ".")
      puts "Press 'q' to quit"
    end

    private :off_to_on, :on_to_off
  end
end