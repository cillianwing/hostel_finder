class HostelFinder::Scraper

  def main_page
    Nokogiri::HTML(open("https://www.hostelworld.com/hoscars"))
  end

  def scrape_categories
    self.main_page.css("main#content section").each do |cats|
      HostelFinder::Category.new(cats)
    end
  end

  def all_hostels

  end

  def self.scrape_hostels(category)
    webpage = Nokogiri::HTML(open("https://www.hostelworld.com/hoscars"))
    # need to scrape the webpage and collect only hostels within the selected category
    cat_hostels = []
    webpage.css("section.category").each do |x|
      if x.css("h3").text == category.name
        x.css("div.column.column-block").each do |y|
          cat_hostels << y
        end
      end
    end
    cat_hostels.each do |info|
      new_hostel = HostelFinder::Hostel.new
      new_hostel.name = info.css("span.hostel-name-full").text
      new_hostel.url = info.css("a.button.hollow").attribute("href").value
      new_hostel.location = info.css("div.hostel-address").text.strip
      category.hostels << new_hostel
    end
    binding.pry
  end

end

# hostel_category = x.css("main#content section h3").text
# hostel_name = x.css("main#content section span.hostel-name-full").text
# hostel_url = x.css("main#content section div.hostel-details a.button.hollow").attribute("href").value
# hostel_location = x.css("main#content section div.hostel-details div.hostel-address").text
