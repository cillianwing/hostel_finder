class HostelFinder::Scraper

  def self.main_page
    Nokogiri::HTML(open("https://www.hostelworld.com/hoscars"))
  end

  def self.scrape_categories
    main_page.css("main#content section").collect { |x| x }
    end
  end

  def all_hostels

  end

  def create_hostels
    # creates Hostel Objects used scraped data
    scrape_categories.each do |hostel|
      hostel.css("div.hostel-details").each do |info|
        HostelFinder::Hostel.new_from_categories(info)
        HostelFinder::Hostel.category(hostel)
      end
    end

  end

end

# hostel_category = x.css("main#content section h3").text
# hostel_name = x.css("main#content section span.hostel-name-full").text
# hostel_url = x.css("main#content section div.hostel-details").attribute("href").value
# hostel_location = x.css("main#content section div.hostel-details div.hostel-address").text
