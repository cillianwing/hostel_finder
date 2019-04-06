class HostelFinder::Hostel
  attr_accessor :name, :location, :url, :category, :rating, :qualities # name, location, url, category are the base. Other wills be dependent on me being able to access the hostelworld site.
  @@all = []

  def initialize(name=nil, location=nil, url=nil, category=nil)
    @name = name
    @location = location
    @url = url
    @category = category
    @@all << self
  end

  def self.new_from_categories(ref)
    self.new(
      ref.css("span.hostel-name-full").text.strip,
      ref.css("div.hostel-address").text.strip,
      ref.css.attribute("href").value,
      #need to figure out category
    )
  end

  def self.all
    @@all
  end

  def rating
    # rating variable = rating scraped from secondary site
  end

  def qualities
    #qualities variable = 3 qualities listed on each hostelworld site
  end

end
