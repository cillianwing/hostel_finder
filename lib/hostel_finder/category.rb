class HostelFinder::Category
  attr_accessor :name, :hostels
  @@all = []

  def initialize(name)
    @name = name.css("h3").text.strip
    @hostels = []
    @@all << self
  end

  def self.all
    @@all
  end

  def add_hostels(hostel) 
    hostel.category=(self) if hostel.category.nil?
    hostels << hostel unless hostels.include?(hostel)
  end

end
