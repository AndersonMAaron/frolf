require 'logger'

module Frolf
  class Caddie
    # Ideal bag composition by percentages
    IDEAL_PERCENTAGES = {
      :putter => 10,
      :midrange => 35,
      :fairway_driver => 35,
      :distance_driver => 20,
      :stable => 20,
      :overstable => 40,
      :understable => 40,
    }

    def initialize(disc_store, opts={})
      @disc_store = disc_store
      @logger = opts.fetch(:logger, Logger.new(STDERR))
    end

    # This ain't pretty, but until I can figure out how to sample an object
    # from a dynamic number of criteria this is how it hasta be
    def get_disc_meets_criteria(bag, criteria={})
      return nil if bag.nil? || bag.empty?
      return bag.discs.sample if criteria.empty?

      sets = []
      criteria.each do |criterion, value|
        sets << bag.discs.select { |disc| disc.send(criterion.to_sym) == value }
      end

      times_in_sets = sets.flatten.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total }
      options = times_in_sets.select { |k, v| v == criteria.keys.size }
      options.empty? ? nil : options.keys.sample
    end

    # Philosophy of disc selection can be found at docs/disc_selection
    def suggest_disc_for_bag(bag)
      # If the bag is empty, suggest a putter as their first disc
      return get_disc_meets_criteria(@disc_store, {:type => :putter}) if bag.empty?

      type = lacking_disc_type(bag)
      criteria = {
        :type => type,
        :stability => lacking_stability_for_type(bag, type),
      }

      get_disc_meets_criteria(@disc_store, criteria)
    end

    def suggest_disc_for_hole(bag, hole_length, hole_trajectory)
      #TODO
    end

    private
      def diff_from_ideal(ideal_percent, part, total)
        ideal_percent - (part.to_f / total.to_f * 100)
      end

      def type_diff_from_ideal(bag, disc_type)
        return IDEAL_PERCENTAGES[disc_type] if bag.empty?
        diff_from_ideal(IDEAL_PERCENTAGES[disc_type], bag.send("#{disc_type.to_sym}s").size, bag.size)
      end

      def stability_diff_from_ideal(bag, disc_type, stability)
        num_stability_discs = bag.send("#{disc_type.to_sym}s").select { |discs| discs.stability == stability }.size
        return IDEAL_PERCENTAGES[stability] if (num_stability_discs == 0)
        diff_from_ideal(IDEAL_PERCENTAGES[stability], num_stability_discs, bag.size)
      end

      def lacking_disc_type(bag)
        from_ideal = {}
        Frolf.disc_types.each do |disc_type|
          from_ideal[disc_type] = type_diff_from_ideal(bag, disc_type)
        end

        # Do not take the absolute value because if from_ideal is negative,
        # it means we have too many of that disc type already
        #
        # max_by returns a two element array [disc_type, type_diff_from_ideal]
        from_ideal.max_by { |k,v| v }.first
      end

      def lacking_stability_for_type(bag, disc_type)
        from_ideal = {}
        Frolf.stabilities.each do |stability|
          from_ideal[stability] = stability_diff_from_ideal(bag, disc_type, stability)
        end

        from_ideal.max_by { |k,v| v }.first
      end
    #end private
  end
end
