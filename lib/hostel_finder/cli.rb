class HostelFinder::CLI

  def call
    puts "Welcome! Let's help you find some of the world's best hostels!"
    hostel_select
    goodbye
  end

  def hostel_select
    input = nil
    while input != "exit"
      # prints a list of the different hostel categories to the user and receives their input
      HostelFinder::Scraper.scrape_categories.each_with_index do |cat, idx|
        puts "#{idx+1}. #{cat.css('h3').text.strip}"
      end
      puts "Please enter a number 1-10 to select a category of hostels you would like more info on:"
      input = gets.strip.to_i

      # list hostels from selected category - what is best way to do this?
    end
    goodbye
  end

  def goodbye
    puts "Goodbye!"
  end

end
