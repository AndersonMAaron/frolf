describe "Frolf::Bag" do
  let(:test_bag) { Frolf::Test.bag }

  it "knows its size" do
    expect(test_bag.size).to eq(0)

    test_bag.add_disc(Frolf::Test.overstable_putter)
    expect(test_bag.size).to eq(1)
  end

  describe "querying contents" do
    # Querying for stability - yes and no
    it "returns true when querying for an overstable disc when the bag contains one" do
      test_bag.add_disc(Frolf::Test.overstable_putter)
      expect(test_bag.has_disc_with(:stability, :overstable)).to be_truthy
    end

    it "returns false when querying for an overstable disc when the bag does not have one" do
      test_bag.add_disc(Frolf::Test.understable_putter)
      expect(test_bag.has_disc_with(:stability, :overstable)).to be_falsey
    end

    # Querying for type - yes and no
    it "returns true when querying for a midrange disc when the bag contains one" do
      test_bag.add_disc(Frolf::Test.overstable_midrange)
      expect(test_bag.has_disc_with(:type, :midrange)).to be_truthy
    end

    it "returns false when querying for a midrange disc when the bag does not have one" do
      test_bag.add_disc(Frolf::Test.overstable_putter)
      expect(test_bag.has_disc_with(:type, :midrange)).to be_falsey
    end
  end

  describe "grouping discs" do 
    # Stability
    it "can retrieve all understable discs" do 
      test_bag.add_discs([
        Frolf::Test.understable_putter,
        Frolf::Test.understable_fairway_driver,
        Frolf::Test.overstable_midrange,
      ])

      expect(test_bag.understables.size).to eq(2)
    end

    it "can retrieve all overstable discs" do 
      test_bag.add_discs([
        Frolf::Test.overstable_putter,
        Frolf::Test.overstable_fairway_driver,
        Frolf::Test.understable_midrange,
      ])

      expect(test_bag.overstables.size).to eq(2)
    end

    it "can retrieve all stable discs" do 
      test_bag.add_discs([
        Frolf::Test.stable_putter,
        Frolf::Test.stable_fairway_driver,
        Frolf::Test.understable_midrange,
      ])

      expect(test_bag.stables.size).to eq(2)
    end

    # Type
    it "can retrieve all putters" do 
      test_bag.add_discs([
        Frolf::Test.understable_putter,
        Frolf::Test.overstable_putter,
        Frolf::Test.overstable_midrange,
      ])

      expect(test_bag.putters.size).to eq(2)
    end

    it "can retrieve all midrangers" do 
      test_bag.add_discs([
        Frolf::Test.overstable_midrange,
        Frolf::Test.understable_midrange,
        Frolf::Test.overstable_putter,
      ])

      expect(test_bag.midranges.size).to eq(2)
    end

    it "can retrieve all fairway drivers" do 
      test_bag.add_discs([
        Frolf::Test.stable_fairway_driver,
        Frolf::Test.stable_fairway_driver,
        Frolf::Test.understable_midrange,
      ])

      expect(test_bag.fairway_drivers.size).to eq(2)
    end

    it "can retrieve all distance drivers" do 
      test_bag.add_discs([
        Frolf::Test.stable_distance_driver,
        Frolf::Test.understable_distance_driver,
        Frolf::Test.understable_midrange,
      ])

      expect(test_bag.distance_drivers.size).to eq(2)
    end
  end
end
