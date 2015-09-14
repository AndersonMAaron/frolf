module Frolf
  module Test
    def self.bag
      Frolf::Bag.new(
        {
          :name => 'Test Bag',
          :discs => [],
        }
      )
    end

    def self.fill_bag(bag)
      Frolf.disc_types.each do |disc_type|
        Frolf.stabilities.each do |stability|
          bag.add_disc(self.send("#{stability}_#{disc_type}".to_sym))
        end
      end
    end

    def self.overstable_putter
      Frolf::Disc.new(
        'Test Overstable Putter',
        2,
        3,
        0,
        2
      )
    end

    def self.understable_putter
      Frolf::Disc.new(
        'Test Understable Putter',
        2,
        3,
        2,
        0
      )
    end

    def self.stable_putter
      Frolf::Disc.new(
        'Test Stable Putter',
        2,
        3,
        2,
        2
      )
    end

    def self.overstable_midrange
      Frolf::Disc.new(
        'Test Overstable Midrange',
        5,
        3,
        0,
        2
      )
    end

    def self.understable_midrange
      Frolf::Disc.new(
        'Test Understable Midrange',
        5,
        3,
        2,
        0
      )
    end

    def self.stable_midrange
      Frolf::Disc.new(
        'Test Stable Midrange',
        5,
        3,
        2,
        2
      )
    end

    def self.overstable_fairway_driver
      Frolf::Disc.new(
        'Test Overstable Fairway Driver',
        8,
        3,
        0,
        2
      )
    end

    def self.understable_fairway_driver
      Frolf::Disc.new(
        'Test Understable Fairway Driver',
        8,
        3,
        2,
        0
      )
    end

    def self.stable_fairway_driver
      Frolf::Disc.new(
        'Test Stable Fairway Driver',
        8,
        3,
        2,
        2
      )
    end

    def self.overstable_distance_driver
      Frolf::Disc.new(
        'Test Overstable Distance Driver',
        11,
        3,
        0,
        2
      )
    end

    def self.understable_distance_driver
      Frolf::Disc.new(
        'Test Understable Distance Driver',
        11,
        3,
        2,
        0
      )
    end

    def self.stable_distance_driver
      Frolf::Disc.new(
        'Test Stable Distance Driver',
        11,
        3,
        2,
        2
      )
    end
  end
end
