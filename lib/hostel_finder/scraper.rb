class HostelFinder::Scraper

  def main_page
    Nokogiri::HTML(open("https://www.hostelworld.com/hoscars"))
  end

  def hostel_categories
    hostel_a = []
    main_page.css("main#content section h3").collect do |x|
      hostel_a << x.text.strip unless x.text.strip == "Best Hostels by Country" || x.text.strip == "Best Hostels by Continent" || x.text.strip == "All other winners" || x.text.strip == "Best Hostel Chain" || x.text.strip == "Best Hostel for Groups"
    end
    hostel_a
  end

end
