class HostelFinder::CLI

  def call
    puts "Welcome! Let's help you find some of the world's best hostels!"
    HostelFinder::Scraper.new.scrape_categories
    print_categories
    category_select
    hostel_select
    goodbye
  end

  def category_select
    max = HostelFinder::Category.all.length
    puts "\nPlease enter a number 1-#{max} to select a category of hostels you would like more info on."
    input = gets.strip.to_i
    if input.between?(1,max)
      category = HostelFinder::Category.all[input-1]
      display_category_hostels(category)
    else
      puts "\nPlease enter a valid number 1-#{max}."
      print_categories
      category_select
    end
  end

  def hostel_select

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
    puts "Displaying all hostels for the #{category.name} category."
  end

end
