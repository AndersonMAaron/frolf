module Frolf
  class Disc
    attr_reader :color,
                :fade,
                :glide,
                :manufacturer,
                :name,
                :speed,
                :stability,
                :turn,
                :type,
                :weight

    def initialize(name, speed, glide, turn, fade, opts={})
      @color = opts.fetch(:color, nil)
      @fade = fade
      @glide = glide
      @manufacturer = opts.fetch(:manufacturer, determine_manufacturer_from(name))
      @name = name
      @speed = speed
      @stability = opts.fetch(:stability, determine_stability_from(turn, fade))
      @turn = turn
      @type = opts.fetch(:type, determine_type_from(speed))
      @weight = opts.fetch(:weight, nil)
    end

    private
      def determine_stability_from(turn, fade)
        (turn == fade) ? :stable : (turn > fade) ? :understable : :overstable
      end

      def determine_type_from(speed)
        case
          when speed <= 3
            :putter
          when speed > 3 && speed <= 6
            :midrange
          when speed > 6 && speed <= 9
            :fairway_driver
          else
            :distance_driver
        end
      end

      # TODO there's more
      def determine_manufacturer_from(name)
        manufacturer = case name.downcase
          when /innova/
            'Innova'
          when /discraft/
            'Discraft'
          when /discmania/
            'Discmania'
          else
            'Unknown'
        end
      end
  end
end
