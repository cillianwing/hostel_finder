class HostelFinder::Scraper

  def main_page
    Nokogiri::HTML(open("https://www.hostelworld.com/hoscars"))
  end

  def scrape_categories
    # scrape main page to collect hostel categories
    self.main_page.css("main#content section").each do |cats|
      name = cats.css("h3").text.strip
      # exclude a few categories due to forms requiring user searches/submits, beyond scope of project for now
      HostelFinder::Category.new(cats) unless name == "Best Hostels by Country" ||
      name == "Best Hostels by Continent" ||
      name.include?("Best Hostel Chain")
    end
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
      # create new Hostel instance for each hostel within selected category
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
    # scrape page for selected hostel and collect additional info
    webpage = Nokogiri::HTML(open(hostel.url))


    # add attributes to hostel instance
    hostel.overall_rating = webpage.css("div.rating-summary.rating-high-rating.rating-xlarge div.score").text.strip
    hostel.char1 = webpage.css("ul.rating-factors li.rating-factors-item span.rating-factors-label")[0].text.strip
    hostel.char2 = webpage.css("ul.rating-factors li.rating-factors-item span.rating-factors-label")[1].text.strip
    hostel.char3 = webpage.css("ul.rating-factors li.rating-factors-item span.rating-factors-label")[2].text.strip
    indv_ratings = webpage.css("section.row-arrow.mb-5 li.small-12.medium-4.large-3.columns p.rating-label")
    # each of the ratings below provide the title and rating number in the text (ex. "Value for Money 9.3").
    # split and pop used to gather only the rating number, which is always last part of the string
    hostel.value = indv_ratings[0].text.strip.split(" ").pop
    hostel.security = indv_ratings[1].text.strip.split(" ").pop
    hostel.location_rating = indv_ratings[2].text.strip.split(" ").pop
    hostel.staff = indv_ratings[3].text.strip.split(" ").pop
    hostel.atmosphere = indv_ratings[4].text.strip.split(" ").pop
    hostel.cleanliness = indv_ratings[5].text.strip.split(" ").pop
    hostel.facilities = indv_ratings[6].text.strip.split(" ").pop
  end
  
end
