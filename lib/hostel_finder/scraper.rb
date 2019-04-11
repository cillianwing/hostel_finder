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
    indv_ratings = webpage.css("section.row-arrow.mb-5 li.small-12.medium-4.large-3.columns p.rating-label")
    hostel.value = indv_ratings[0].text.strip.split(" ").pop
    hostel.security = indv_ratings[1].text.strip.split(" ").pop
    hostel.location_rating = indv_ratings[2].text.strip.split(" ").pop
    hostel.staff = indv_ratings[3].text.strip.split(" ").pop
    hostel.atmosphere = indv_ratings[4].text.strip.split(" ").pop
    hostel.cleanliness = indv_ratings[5].text.strip.split(" ").pop
    hostel.facilities = indv_ratings[6].text.strip.split(" ").pop

  end

# test code while brainstorming room additions
  def self.scrape_rooms(hostel, search)
    booking_page = "#{hostel.url}?dateFrom=#{search[:start_date]}&dateTo=#{search[:end_date]}&number_of_guests=#{search[:guests]}&origin=microsite"
    webpage = Nokogiri::HTML(open(booking_page))
    # scrape page and collect all available rooms/beds
    hostel_rooms = []
    # am I able to use 'form' selector? Not finding anything
    webpage.css("form.form table.table.table-availability tr.room-tr.room-tr-last").each do |x|
      hostel_rooms << x
    end
    hostel_rooms.each do |info|
      # create new Hostel instance
      new_room = HostelFinder::Rooms.new

      # add attributes to Room instance that was created
      new_room.room_type = info.css("p.room-label span.room-title").text.strip
      new_room.room_desc = info.css("div.text-dark-gray.text-small").text.strip
      new_room.availability = info.css("div.badge.badge-small.badge-outline-blue.badge-availability.badge-room-image").text.strip
      new_room.price =info.css("span.rate-type-price").text.strip

      # associate Hostel and Room objects
      hostel.add_room(new_room)
    end
  end

end
