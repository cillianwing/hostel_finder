class HostelFinder::CLI
  attr_accessor :category, :hostel

  def call
    puts "\nWelcome! Let us help you find some of the world's best hostels!"
    puts "Enter 'exit' at any time to quit the program."
    HostelFinder::Scraper.new.scrape_categories
    print_categories
    category_select
    hostel_select
    restart
    goodbye
  end

  def category_select

    # section for selecting category
    max_cats = HostelFinder::Category.all.length
    puts "\nPlease enter a number 1-#{max_cats} to select a category of hostels for which you would like more info."
    input = gets.strip
    if input == "exit"
      goodbye
      exit(true)
    else
      input = input.to_i
      if input.between?(1,max_cats)
        self.category = HostelFinder::Category.all[input-1]
        display_category_hostels(self.category)
      else
        puts "\nInvalid input."
        print_categories
        category_select
      end
    end
  end

  def hostel_select

    # section for selecting hostel from category
    max_hostels = category.hostels.length
    puts "\nPlease enter a number 1-#{max_hostels} to select a hostel for which you would like more info."
    input = gets.strip
    if input == "exit"
      goodbye
      exit(true)
    else
      input = input.to_i
      if input.between?(1, max_hostels)
        self.hostel = category.hostels[input-1]
        display_hostel_details(self.hostel)
      else
        puts "\nInvalid input."
        display_category_hostels(self.category)
        hostel_select(self.hostel)
      end
    end

  end

  def print_categories
    # displayed scraped hostel categories
    HostelFinder::Category.all.each.with_index(1) do |x, idx|
      puts "#{idx}. #{x.name}"
    end
  end

  def display_category_hostels(category)

    # displays scraped hostels from selected categories
    HostelFinder::Scraper.scrape_hostels(category)
    puts "\nHere are the hostels for #{category.name}:"
    category.hostels.each.with_index(1) do |info, index|
      puts "#{index}. #{info.name} in #{info.location}"
    end
  end

  def display_hostel_details(hostel)

    # scrapes selected hostel's website
    HostelFinder::Scraper.scrape_hostel_webpage(hostel)

    # displays additional hostel details
    puts "\n~~~ Hostel Name: #{hostel.name} || Hostel Location: #{hostel.location} ~~~"
    puts ""
    puts "====================================================================================="
    puts "                                Overall Rating: #{hostel.overall_rating}"
    puts "         Known for: #{hostel.char1}, #{hostel.char2}, and #{hostel.char3}"
    puts "                              --- Detailed Ratings ---"
    puts "                 Value For Money: #{hostel.value} | Security: #{hostel.security} | Location: #{hostel.location_rating}"
    puts "                            Staff: #{hostel.staff} | Atmostphere: #{hostel.atmosphere}"
    puts "                          Cleanliness: #{hostel.cleanliness} | Facilities: #{hostel.facilities}"
    puts "====================================================================================="
    puts ""
    puts "Website: #{hostel.url}"

    # ask user if they would like to visit webpage and launch webpage if yes
    open_webpage(hostel)

  end

  def open_webpage(hostel)
    # open new browser window with selected hostel's website if user requests it
    puts "\nWould you like to open the webpage to book your stay at this hostel (Y/N)?"
    input = gets.strip.downcase
    if input == "exit"
      goodbye
      exit(true)
    elsif input == "y"
      Launchy.open(hostel.url)
    end
  end

  def restart
    # returns to beginning of the program; clears previously scraped data
    puts "\nWould you like to view another hostel? (Y/N)"
    input = gets.strip.downcase
    if input == "exit"
      goodbye
      exit(true)
    elsif input == "y"
      HostelFinder::Category.reset
      call
    elsif input != "y" && input != "n"
      puts "\nInvalid input."
      restart
    end
  end

  def goodbye
    puts "\nThank you for using the world's best hostel finder!"
  end

end
