class HostelFinder::Hostel
  attr_accessor :name, :location, :url, :rating, :qualities # name, location, url, category are the base. Other wills be dependent on me being able to access the hostelworld site.
  attr_reader :category
  @@all = []

  def initialize(name, location, url, category=nil)
    @name = name
    @location = location
    @url = url
    self.category=(category) unless category.nil?
    @@all << self
  end

  def self.all
    @@all
  end

  def category=(category)
    @category = category.css("h3").text
    category.add_hostels(self)
  end

  def rating
    # rating variable = rating scraped from secondary site
  end

  def qualities
    #qualities variable = 3 qualities listed on each hostelworld site
  end

end
