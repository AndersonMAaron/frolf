describe "Frolf::Caddie" do
  let(:test_bag) { Frolf::Test.bag }
  let(:test_disc_store) {
    bag = Frolf::Test.bag
    Frolf::Test.fill_bag(bag)
    bag
  }
  let(:test_caddie) { Frolf::Caddie.new(test_disc_store) }

  def is_disc?(object)
    expect(object).not_to be_nil
    expect(object).to be_a(Frolf::Disc)
  end

  describe "finding a disc that meets specified criteria" do
    it "returns nil when the bag is empty" do
      expect(test_caddie.get_disc_meets_criteria(nil, {})).to be_nil
    end

    it "returns a disc when no criteria is specified" do
      test_bag.add_disc(Frolf::Test.overstable_putter)
      disc = test_caddie.get_disc_meets_criteria(test_bag, {})
      is_disc?(disc)
    end

    it "returns a disc meeting stability criterion when only that criterion is specified and the bag contains exactly one" do
      criteria = {
        :stability => :overstable,
      }
      test_bag.add_disc(Frolf::Test.overstable_putter)

      disc = test_caddie.get_disc_meets_criteria(test_bag, criteria)
      is_disc?(disc)
      expect(disc.stability).to eq(:overstable)
    end

    it "returns a disc meeting stability criterion when only that criterion is specified and the bag contains more than one" do
      criteria = {
        :stability => :overstable,
      }
      test_bag.add_disc(Frolf::Test.overstable_putter)
      test_bag.add_disc(Frolf::Test.overstable_distance_driver)

      disc = test_caddie.get_disc_meets_criteria(test_bag, criteria)
      is_disc?(disc)
      expect(disc.stability).to eq(:overstable)
    end

    it "returns a disc meeting type criterion when only that criterion is specified and the bag contains exactly one" do
      criteria = {
        :type => :fairway_driver,
      }
      test_bag.add_disc(Frolf::Test.overstable_fairway_driver)

      disc = test_caddie.get_disc_meets_criteria(test_bag, criteria)
      is_disc?(disc)
      expect(disc.type).to eq(:fairway_driver)
    end

    it "returns a disc meeting type criterion when only that criterion is specified and the bag contains more than one" do
      criteria = {
        :type => :fairway_driver,
      }
      test_bag.add_disc(Frolf::Test.overstable_fairway_driver)
      test_bag.add_disc(Frolf::Test.understable_fairway_driver)

      disc = test_caddie.get_disc_meets_criteria(test_bag, criteria)
      is_disc?(disc)
      expect(disc.type).to eq(:fairway_driver)
    end

    it "returns a disc meeting both type and stability criteria when the bag contains exactly one" do
      criteria = {
        :type => :putter,
        :stability => :overstable,
      }
      test_bag.add_disc(Frolf::Test.overstable_putter)

      disc = test_caddie.get_disc_meets_criteria(test_bag, criteria)
      is_disc?(disc)
      expect(disc.type).to eq(:putter)
      expect(disc.stability).to eq(:overstable)
    end

    it "returns a disc meeting both type and stability criteria if the bag contains more than one" do
      criteria = {
        :type => :putter,
        :stability => :overstable,
      }
      # Add two overstable putters
      test_bag.add_disc(Frolf::Test.overstable_putter)
      test_bag.add_disc(Frolf::Test.overstable_putter)

      disc = test_caddie.get_disc_meets_criteria(test_bag, criteria)
      is_disc?(disc)
      expect(disc.type).to eq(:putter)
      expect(disc.stability).to eq(:overstable)
    end

    it "returns nil when the bag does not contain a disc that meets both type and stability criteria" do
      criteria = {
        :type => :putter,
        :stability => :overstable,
      }
      test_bag.add_disc(Frolf::Test.understable_midrange)

      disc = test_caddie.get_disc_meets_criteria(test_bag, criteria)
      expect(disc).to be_nil
    end

    it "returns nil when the bag does not contain a disc that meets stability criterion" do
      criteria = {
        :stability => :overstable,
      }
      test_bag.add_disc(Frolf::Test.understable_putter)

      disc = test_caddie.get_disc_meets_criteria(test_bag, criteria)
      expect(disc).to be_nil
    end

    it "returns nil when the bag does not contain a disc that meets type criterion" do
      criteria = {
        :type => :midrange,
      }
      test_bag.add_disc(Frolf::Test.understable_putter)

      disc = test_caddie.get_disc_meets_criteria(test_bag, criteria)
      expect(disc).to be_nil
    end

    it "returns nil when the bag does not contain a disc that meets stability criterion but does not meet type criterion" do
      criteria = {
        :type => :putter,
        :stability => :overstable,
      }
      test_bag.add_disc(Frolf::Test.overstable_midrange)

      disc = test_caddie.get_disc_meets_criteria(test_bag, criteria)
      expect(disc).to be_nil
    end
  end

  # TODO these tests are tightly coupled to the currently defined ideal disc type ratios
  # Consider building an engine to test that an action taken at any point has the intention
  # of meeting the ideal ratios.
  describe "suggesting discs to complement a bag" do
    ## Test only disc type selection
    it "chooses a putter as the first disc when the bag is empty" do
      disc = test_caddie.suggest_disc_for_bag(test_bag)

      is_disc?(disc)
      expect(disc.type).to eq(:putter)
    end

    it "chooses a midranger or fairway driver if bag only contains putter" do
      test_bag.add_disc(Frolf::Test.stable_putter)
      disc = test_caddie.suggest_disc_for_bag(test_bag)

      is_disc?(disc)
      expect([:fairway_driver, :midrange].include?(disc.type)).to be_truthy
    end

    it "chooses a fairway driver if the bag contains a putter and midranger" do
      test_bag.add_discs([
        Frolf::Test.stable_putter,
        Frolf::Test.stable_midrange,
      ])

      disc = test_caddie.suggest_disc_for_bag(test_bag)
      is_disc?(disc)
      expect(disc.type).to eq(:fairway_driver)
    end

    it "chooses a putter if the bag contains one of every other type" do
      test_bag.add_discs([
        Frolf::Test.stable_distance_driver,
        Frolf::Test.stable_midrange,
        Frolf::Test.stable_fairway_driver,
      ])

      disc = test_caddie.suggest_disc_for_bag(test_bag)
      is_disc?(disc)
      expect(disc.type).to eq(:putter)
    end

    it "chooses a distance driver if the bag contains one of every other type" do
      test_bag.add_discs([
        Frolf::Test.stable_putter,
        Frolf::Test.stable_midrange,
        Frolf::Test.stable_fairway_driver,
      ])

      disc = test_caddie.suggest_disc_for_bag(test_bag)
      is_disc?(disc)
      expect(disc.type).to eq(:distance_driver)
    end

    it "chooses a fairway driver if the bag contains one of every other type" do
      test_bag.add_discs([
        Frolf::Test.stable_putter,
        Frolf::Test.stable_midrange,
        Frolf::Test.stable_distance_driver,
      ])

      disc = test_caddie.suggest_disc_for_bag(test_bag)
      is_disc?(disc)
      expect(disc.type).to eq(:fairway_driver)
    end

    it "chooses a midrange if the bag contains one of every other type" do
      test_bag.add_discs([
        Frolf::Test.stable_putter,
        Frolf::Test.stable_distance_driver,
        Frolf::Test.stable_fairway_driver,
      ])

      disc = test_caddie.suggest_disc_for_bag(test_bag)
      is_disc?(disc)
      expect(disc.type).to eq(:midrange)
    end

    ## Test disc type and stability selection
    it "chooses an overstable midrange when the bag lacks midranges but has understable ones" do
      test_bag.add_discs([
        # 2 7 7 4
        Frolf::Test.overstable_putter,
        Frolf::Test.understable_putter,
        Frolf::Test.understable_midrange,
        Frolf::Test.understable_midrange,
        Frolf::Test.understable_midrange,
        Frolf::Test.understable_midrange,
        Frolf::Test.overstable_fairway_driver,
        Frolf::Test.overstable_fairway_driver,
        Frolf::Test.overstable_fairway_driver,
        Frolf::Test.understable_fairway_driver,
        Frolf::Test.understable_fairway_driver,
        Frolf::Test.understable_fairway_driver,
        Frolf::Test.understable_fairway_driver,
        Frolf::Test.overstable_distance_driver,
        Frolf::Test.overstable_distance_driver,
        Frolf::Test.overstable_distance_driver,
        Frolf::Test.understable_distance_driver,
        Frolf::Test.understable_distance_driver,
        Frolf::Test.understable_distance_driver,
        Frolf::Test.understable_distance_driver,
      ])

      disc = test_caddie.suggest_disc_for_bag(test_bag)
      is_disc?(disc)
      expect(disc.type).to eq(:midrange)
      expect(disc.stability).to eq(:overstable)
    end

    it "chooses an understable distance driver when the bag lacks distance drivers but has overstable ones" do
      test_bag.add_discs([
        # 2 7 7 4
        Frolf::Test.overstable_putter,
        Frolf::Test.understable_putter,
        Frolf::Test.understable_midrange,
        Frolf::Test.understable_midrange,
        Frolf::Test.understable_midrange,
        Frolf::Test.understable_midrange,
        Frolf::Test.overstable_midrange,
        Frolf::Test.overstable_midrange,
        Frolf::Test.overstable_midrange,
        Frolf::Test.overstable_fairway_driver,
        Frolf::Test.overstable_fairway_driver,
        Frolf::Test.overstable_fairway_driver,
        Frolf::Test.understable_fairway_driver,
        Frolf::Test.understable_fairway_driver,
        Frolf::Test.understable_fairway_driver,
        Frolf::Test.understable_fairway_driver,
        Frolf::Test.overstable_distance_driver,
        Frolf::Test.overstable_distance_driver,
      ])

      disc = test_caddie.suggest_disc_for_bag(test_bag)
      is_disc?(disc)
      expect(disc.type).to eq(:distance_driver)
      expect(disc.stability).to eq(:understable)
    end
  end
end
