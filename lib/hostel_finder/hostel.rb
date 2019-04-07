class HostelFinder::Hostel
  attr_accessor :name, :location, :url, :rating, :qualities
  attr_reader :category
  @@all = []

  def rating
    # rating variable = rating scraped from secondary site
  end

  def qualities
    #qualities variable = 3 qualities listed on each hostelworld site
  end

end
