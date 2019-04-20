class HostelFinder::CLI
  attr_accessor :category, :hostel, :start_date, :end_date, :guests

  def call
    puts "\nWelcome! Let us help you find some of the world's best hostels!".green.bold
    puts "Enter 'exit' at any time to quit the program.\n".red
    HostelFinder::Scraper.new.scrape_categories
    print_categories
    category_select
    hostel_select
    restart?
    goodbye
  end

  def category_select

    # section for selecting category
    max_cats = HostelFinder::Category.all.length
    puts "Please enter a number 1-#{max_cats} to select a category of hostels for which you would like more info.\n".yellow
    input = gets.strip
    if input == "exit"
      goodbye
      exit(true)
    else
      input = input.to_i
      # if user inputs string, .to_i will convert this to zero and "Invalid input" will be returned based on below.
      if input.between?(1,max_cats)
        # add selected category to category instance variable to reference/call later in program
        self.category = HostelFinder::Category.all[input-1]
        display_category_hostels(self.category)
      else
        puts "\nInvalid input.".red
        sleep(1)
        print_categories
        category_select
      end
    end
  end

  def hostel_select

    # section for selecting hostel from category
    max_hostels = category.hostels.length
    puts "Please enter a number 1-#{max_hostels} to select a hostel for which you would like more info.\n".yellow
    input = gets.strip
    if input == "exit"
      goodbye
      exit(true)
    else
      input = input.to_i
      if input.between?(1,max_hostels)
        # add selected hostel to hostel instance variable to reference/call later in program
        self.hostel = category.hostels[input-1]
        display_hostel_details(self.hostel)
      else
        puts "\nInvalid input.".red
        sleep(1)
        category.hostels.clear
        display_category_hostels(self.category)
        hostel_select
      end
    end

  end

  def print_categories
    # displayed scraped hostel categories
    HostelFinder::Category.all.each.with_index(1) do |x, idx|
      puts "#{idx}. #{x.name}".cyan
    end
  end

  def display_category_hostels(category)

    # displays scraped hostels from selected categories
    HostelFinder::Scraper.scrape_hostels(category)
    puts "==============================".yellow
    puts "\nBelow are the hostels for the '#{category.name}' category:\n".yellow
    category.hostels.each.with_index(1) do |info, index|
      puts "#{index}. #{info.name} in #{info.location}".cyan
    end
  end

  def display_hostel_details(hostel)

    # scrapes selected hostel's website
    HostelFinder::Scraper.scrape_hostel_webpage(hostel)

    # displays additional hostel details
    puts "==============================".yellow
    puts "\n~~~ Hostel Name: #{hostel.name} || Hostel Location: #{hostel.location} ~~~".cyan
    puts ""
    puts "=====================================================================================".white
    puts ""
    puts "                                Overall Rating: #{hostel.overall_rating}".cyan
    puts "         Known for: #{hostel.char1}, #{hostel.char2}, and #{hostel.char3}".cyan
    puts ""
    puts "                              --- Detailed Ratings ---".cyan
    puts "                 Value For Money: #{hostel.value} | Security: #{hostel.security} | Location: #{hostel.location_rating}".cyan
    puts "                            Staff: #{hostel.staff} | Atmostphere: #{hostel.atmosphere}".cyan
    puts "                          Cleanliness: #{hostel.cleanliness} | Facilities: #{hostel.facilities}".cyan
    puts ""
    puts "=====================================================================================".white
    puts ""
    puts "Website: #{hostel.url}".cyan


    #open_webpage(hostel)
    launch_booking

  end

=begin #added more functionality to this through launch_booking method
  def open_webpage(hostel)
    # open new browser window with selected hostel's website if user requests it
    puts "\nWould you like to open the webpage to book your stay at this hostel (Y/N)?\n".yellow
    input = gets.strip.downcase
    if input == "exit"
      goodbye
      exit(true)
    elsif input == "y"
      Launchy.open(hostel.url)
    elsif input != "exit" && input != "y" && input != "n"
      puts "\nInvalid input.".red
      sleep(1)
      open_webpage(hostel)
    end
  end
=end

  def restart?
    # returns to beginning of the program; clears previously scraped data
    puts "\nWould you like to view another hostel? (Y/N)\n".yellow
    input = gets.strip.downcase
    if input == "exit"
      goodbye
      exit(true)
    elsif input == "y"
      HostelFinder::Category.reset
      call
    elsif input != "y" && input != "n"
      puts "\nInvalid input.".red
      sleep(1)
      restart?
    end
  end

  def goodbye
    puts "\nThank you for using the world's best hostel finder!".green
  end

  def launch_booking
    puts "\n==============================".yellow
    puts "\nWould you like to search booking options for a specific date range at this hostel? (Y/N)\n".yellow
    input = gets.strip.downcase
    if input == "exit"
      goodbye
      exit(true)
    elsif input == "y"
      booking_start
      booking_end
      booking_guests

      search = {:start_date => self.start_date, :end_date => self.end_date, :guests => self.guests}
      booking_page = "#{hostel.url}?dateFrom=#{search[:start_date]}&dateTo=#{search[:end_date]}&number_of_guests=#{search[:guests]}&origin=microsite"
      Launchy.open(booking_page)
    end
  end

  def booking_start
    current_date = Time.now
    today_s = current_date.strftime("%Y-%m-%d")
    day_1 = 86400
    days_180 = day_1 * 180
    puts "\nPlease enter an arrival date for your booking within the next 180 days (YYYY-MM-DD format):\n".yellow
    input = gets.strip
    if input == "exit"
      goodbye
      exit(true)
    elsif (Date.parse(input) rescue false) && input >= today_s && input <= (current_date + days_180).strftime("%Y-%m-%d")
      self.start_date = input
    else
      puts "\nPlease enter a valid date in the format YYYY-MM-DD (ex. 2019-05-31).\n".red
      sleep(2)
      booking_start
    end
  end

  def booking_end
    day_1 = 86400
    days_14 = day_1 * 14
    start_array = self.start_date.split("-")
    puts "\nPlease enter a departure date within 14 days of arrival (YYYY-MM-DD format):\n".yellow
    input = gets.strip
    if input == "exit"
      goodbye
      exit(true)
    elsif (Date.parse(input) rescue false) && input > start_date && input <= (Time.new(start_array[0], start_array[1], start_array[2]) + days_14).strftime("%Y-%m-%d")
      self.end_date = input
    else
      puts "\nPlease enter a valid date in the format YYYY-MM-DD (ex. 2019-06-13):\n".red
      sleep(2)
      booking_end
    end
  end

  def booking_guests
    puts "\nPlease enter the number of guests for your booking (max of 12):".yellow
    input = gets.strip
    if input == "exit"
      goodbye
      exit(true)
    elsif input.to_i.between?(1, 12)
      self.guests = input
    else
      puts "\nPlease enter a valid number of guests between 1 and 12.\n".red
      sleep(2)
      booking_guests
    end
  end

end
