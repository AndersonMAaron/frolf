describe "Frolf::Disc" do
  it "can initialize given all possible arguments" do
    test_color = 'blue'
    test_weight = '160g'
    test_stability = 'stable'
    test_manufacturer = 'Test Manufacturer'

    disc = Frolf::Disc.new(
      'Test Disc',
      5,
      5,
      1,
      1,
      {
        :color => test_color,
        :weight => test_weight,
        :manufacturer => test_manufacturer,
        :stability => test_stability,
      }
    )

    expect(disc).to be_a(Frolf::Disc)
    expect(disc.stability).to eq(test_stability)
    expect(disc.manufacturer).to eq(test_manufacturer)
    expect(disc.color).to eq(test_color)
    expect(disc.weight).to eq(test_weight)
  end

  describe "calculating stability on initialization" do
    it "determines a disc is overstable when fade is greater than turn" do
      disc = Frolf::Disc.new(
        'Test Disc',
        5, # speed
        5, # glide
        0, # turn
        1  # fade
      )

      expect(disc).to be_a(Frolf::Disc)
      expect(disc.stability).to eq(:overstable)
    end

    it "determines a disc is understable when turn is greater than fade" do
      disc = Frolf::Disc.new(
        'Test Disc',
        5, # speed
        5, # glide
        1, # turn
        0  # fade
      )

      expect(disc).to be_a(Frolf::Disc)
      expect(disc.stability).to eq(:understable)
    end

    it "determines a disc is stable when turn is equal to fade" do
      disc = Frolf::Disc.new(
        'Test Disc',
        5, # speed
        5, # glide
        1, # turn
        1  # fade
      )

      expect(disc).to be_a(Frolf::Disc)
      expect(disc.stability).to eq(:stable)
    end
  end
end
