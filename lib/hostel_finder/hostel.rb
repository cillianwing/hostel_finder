class HostelFinder::Hostel
  attr_accessor :name, :location, :url, :category, :overall_rating, :char1, :char2, :char3, :value, :security,
  :location_rating, :staff, :atmosphere, :cleanliness, :facilities

=begin
# code that would have been used for room selection
  @@all = []
  attr_reader :rooms

  def initialize
    @rooms = []
    @@all << self
  end

  def self.all
    @@all
  end

  def self.add_room(new_room)
    self.rooms << new_room
    new_room.hostel = self
  end
=end
end
