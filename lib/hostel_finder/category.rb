class HostelFinder::Category
  attr_accessor :name
  attr_reader :hostels
  @@all = []

  def initialize(name)
    @name = name.css("h3").text.strip
    @hostels = []
    @@all << self
  end

  def self.all
    @@all
  end

  def add_hostel(new_hostel)
    self.hostels << new_hostel
    new_hostel.category = self.name
  end

  def self.reset
    @@all.clear
  end

end
