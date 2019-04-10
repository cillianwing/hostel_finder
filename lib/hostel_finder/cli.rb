class HostelFinder::CLI

  def call
    puts "Welcome! Let's help you find some of the world's best hostels!"
    HostelFinder::Scraper.new.scrape_categories
    print_categories
    hostel_select
    goodbye
  end

  def hostel_select
    max = HostelFinder::Category.all.length
    puts "\nPlease enter a number 1-#{max} to select a category of hostels you would like more info on."
    input = gets.strip.to_i
    if input.between?(1,max)
      category = HostelFinder::Category.all[input-1]
      display_category_hostels(category)
    else
      puts "\nInvalid input."
      print_categories
      hostel_select
    end
  end

  def goodbye
    puts "Goodbye!"
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

end
