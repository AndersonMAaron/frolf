module Frolf

  def self.disc_types
    [
      :putter,
      :midrange,
      :fairway_driver,
      :distance_driver,
    ]
  end

  def self.stabilities
    [
      :stable,
      :understable, 
      :overstable,
    ]
  end

  # The name doesn't have to be this long, but I like the homophone
  def self.read_discs_from_disk(location)

  end
end
