class HostelFinder::CLI
  attr_accessor :category, :hostel

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
    puts "\nWould you like to search booking options for a specific date range at this hostel? (Y/N)".yellow
    input = gets.strip.downcase
    if input == "exit"
      goodbye
      exit(true)
    elsif input == "y"
      # user input to be used for room search
      puts "\nPlease enter an arrival date for your booking (YYYY-MM-DD format):".yellow
      start_date = gets.strip
      puts "\nPlease enter a departure date for your booking (YYYY-MM-DD format):".yellow
      end_date = gets.strip
      puts "\nPlease enter the number of guests for your booking:".yellow
      guests = gets.strip
      search = {:start_date => start_date, :end_date => end_date, :guests => guests}

      # scrape using user input
      # webpage = HostelFinder::Scraper.scrape_rooms(hostel, search)
      booking_page = "#{hostel.url}?dateFrom=#{search[:start_date]}&dateTo=#{search[:end_date]}&number_of_guests=#{search[:guests]}&origin=microsite"
      Launchy.open(booking_page)
    end
  end

end
