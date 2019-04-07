class HostelFinder::Hostel
  attr_accessor :name, :location, :url, :category, :rating, :qualities # name, location, url, category are the base. Other wills be dependent on me being able to access the hostelworld site.
  @@all = []

  def initialize(name, location, url)
    @name = name
    @location = location
    @url = url
    @@all << self
  end

  def self.new_from_categories(ref)
    self.new(
      ref.css("span.hostel-name-full").text.strip,
      ref.css("div.hostel-address").text.strip,
      ref.css("a.button.hollow").attribute("href").value,
    )
  end

  def self.all
    @@all
  end

  def category(category)
    @category = category.css("h3").text
  end

  def rating
    # rating variable = rating scraped from secondary site
  end

  def qualities
    #qualities variable = 3 qualities listed on each hostelworld site
  end

end
