class HostelFinder::CLI

  def call
    puts "Welcome! Let's help you find some of the world's best hostels!"
    # call hostel_type that accepts user input for the type of hostels to look at
  end

  def hostel_type
    Scraper.hostel_categories
    puts "Please enter a number 1-10 to select a category of hostels:"
    input = gets.strip
  end

end
