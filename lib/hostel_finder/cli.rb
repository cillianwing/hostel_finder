class HostelFinder::CLI
  attr_accessor :category, :hostel

  def call
    puts "Welcome! Let's help you find some of the world's best hostels!"
    HostelFinder::Scraper.new.scrape_categories
    print_categories
    category_select
    hostel_select

    goodbye
  end

  def category_select

    # section for selecting category
    max_cats = HostelFinder::Category.all.length
    puts "\nPlease enter a number 1-#{max_cats} to select a category of hostels for which you would like more info."
    input = gets.strip.to_i
    if input.between?(1,max_cats)
      self.category = HostelFinder::Category.all[input-1]
      display_category_hostels(self.category)
    else
      puts "\nInvalid input."
      print_categories
      category_select
    end
  end

  def hostel_select

    # section for selecting hostel from category
    max_hostels = category.hostels.length
    puts "\nPlease enter a number 1-#{max_hostels} to select a hostel for which you would like more info."
    input = gets.strip.to_i
    if input.between?(1, max_hostels)
      self.hostel = category.hostels[input-1]
      display_hostel_details(self.hostel)
    else
      puts "\nInvalid input."
      display_category_hostels(self.category)
      hostel_select(self.hostel)
    end

  end

  def goodbye
    puts "\nGoodbye!"
  end

  def print_categories
    HostelFinder::Category.all.each.with_index(1) do |x, idx|
      puts "#{idx}. #{x.name}"
    end
  end

  def display_category_hostels(category)
    HostelFinder::Scraper.scrape_hostels(category)
    puts "Here are the hostels for #{category.name}:"
    category.hostels.each.with_index(1) do |info, index|
      puts "#{index}. #{info.name} in #{info.location}"
    end
  end

  def display_hostel_details(hostel)
    HostelFinder::Scraper.scrape_hostel_webpage(hostel)
    puts "Hostel Name: #{hostel.name} || Hostel Location: #{hostel.location}"
    puts "Website: #{hostel.url}"
    puts "This hostel is known for: #{hostel.char1}, #{hostel.char2}, and #{hostel.char3}."
    puts "Overall Rating:#{hostel.overall_rating}"
    # puts rating

    # ask user if they would like to visit webpage and launch webpage if yes
    open_webpage(hostel)

  end

  def open_webpage(hostel)
    puts "\nWould you like to open the webpage to book your stay at this hostel? (Y/N)"
    input = gets.strip.downcase
    if input == "y"
      Launchy.open(hostel.url)
    end
  end

end
