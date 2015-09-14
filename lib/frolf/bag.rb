require 'logger'

module Frolf
  class Bag
    attr_reader :discs

    def initialize(opts={})
      @name = opts.fetch(:name, '')
      @discs = opts.fetch(:discs, [])
      @logger = opts.fetch(:logger, Logger.new(STDERR))
      @log_name = self.class.name.split('::').last
    end

    def size
      discs.size
    end

    def empty?
      size == 0
    end

    def has_disc_with(criteria, value)
      !discs.select { |disc| disc.send(criteria.to_sym) == value }.empty?
    end

    def add_disc(disc)
      @logger.error(@log_name) { "ERROR: tried to add a non-Disc '#{disc}' to this bag. Could it possibly be beer?" } unless disc.is_a?(Frolf::Disc)
      @discs << disc
    end

    def add_discs(discs)
      discs.each { |disc| add_disc(disc) }
    end

    # This might not be necessary, but it was fun to write it
    Frolf.disc_types.each do |disc_type|
      define_method("#{disc_type}s".to_sym) { discs.select { |d| d.type == disc_type } }
    end
    Frolf.stabilities.each do |stability|
      define_method("#{stability}s".to_sym) { discs.select { |d| d.stability == stability } }
    end
  end
end
