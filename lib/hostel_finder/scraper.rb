class HostelFinder::Scraper

  def main_page
    Nokogiri::HTML(open("https://www.hostelworld.com/hoscars"))
  end

  def scrape_categories
    self.main_page.css("main#content section").each do |cats|
      name = cats.css("h3").text.strip
      HostelFinder::Category.new(cats) unless name == "Best Hostels by Country" ||
      name == "Best Hostels by Continent" ||
      name.include?("Best Hostel Chain")
    end
  end

  def all_hostels

  end

  def self.scrape_hostels(category)
    webpage = Nokogiri::HTML(open("https://www.hostelworld.com/hoscars"))
    # need to scrape the webpage and collect only hostels within the selected category
    cat_hostels = []
    webpage.css("section.category").each do |x|
      if x.css("h3").text.strip == category.name
        x.css("div.column.column-block").each do |y|
          cat_hostels << y
        end
      end
    end
    cat_hostels.each do |info|
      # create new Hostel instance
      new_hostel = HostelFinder::Hostel.new

      # add attributes to Hostel instance that was created
      new_hostel.name = info.css("span.hostel-name-full").text.strip
      new_hostel.url = info.css("a.button.hollow").attribute("href").value
      new_hostel.location = info.css("div.hostel-address").text.strip

      # associate Hostel and Category objects
      category.add_hostel(new_hostel)
    end
  end

  def self.scrape_hostel_webpage(hostel)
    # scrape page for selected hostel
    webpage = Nokogiri::HTML(open(hostel.url))

    # add attributes to hostel instance
    hostel.overall_rating = webpage.css("div.rating-summary.rating-high-rating.rating-xlarge div.score").text.strip
    hostel.char1 = webpage.css("ul.rating-factors li.rating-factors-item span.rating-factors-label")[0].text.strip
    hostel.char2 = webpage.css("ul.rating-factors li.rating-factors-item span.rating-factors-label")[1].text.strip
    hostel.char3 = webpage.css("ul.rating-factors li.rating-factors-item span.rating-factors-label")[2].text.strip
    #binding.pry

  end

end
