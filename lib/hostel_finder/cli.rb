class HostelFinder::CLI

  def call
    puts "Welcome! Let's help you find some of the world's best hostels!"
    hostel_select
    goodbye
  end

  def hostel_select
    # prints a list of the different hostel categories to the user and receives their input
    HostelFinder::Scraper.new.scrape_categories
    #print_categories
    binding.pry
    puts "Please enter a number 1-10 to select a category of hostels you would like more info on:"
    input = gets.strip.to_i

    # list hostels from selected category - what is best way to do this?
  end

  def goodbye
    puts "Goodbye!"
  end

  def print_categories
    HostelFinder::Category.all.each_with_index do |x, idx|
      puts "#{idx+1}. #{x.name}"
    end
  end

end
