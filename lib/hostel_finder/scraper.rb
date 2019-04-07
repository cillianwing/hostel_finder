class HostelFinder::Scraper

  def main_page
    Nokogiri::HTML(open("https://www.hostelworld.com/hoscars"))
  end

  def scrape_categories
    self.main_page.css("main#content section").collect { |x| x }
  end

  def all_hostels

  end

  def create_hostels
    # creates Hostel Objects used scraped data
    self.scrape_categories.each do |hostel|
      hostel.css("div.column.column-block").each do |info|
        HostelFinder::Hostel.new_from_categories(info)
        HostelFinder::Hostel.category(hostel)
      end
    end

  end

end

# hostel_category = x.css("main#content section h3").text
# hostel_name = x.css("main#content section span.hostel-name-full").text
# hostel_url = x.css("main#content section div.hostel-details a.button.hollow").attribute("href").value
# hostel_location = x.css("main#content section div.hostel-details div.hostel-address").text
