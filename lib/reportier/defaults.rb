module Reportier
  class Defaults
    attr_accessor :trackers, :reporting_vars, :reporters,
      :persister

    def self.global
      @global ||= new
    end

    def initialize(opts={})
      initialize_defaults
      @reporting_vars.merge! Hash(opts[:reporting_vars])
    end

    def configure 
      yield self
    end

    def update_reporting_vars(hash)
      @reporting_vars.merge!(hash)
    end

    def trackers=(opts)
      @trackers = Hash.new(0)
      @trackers.merge! opts
    end

    def reporters=(opts)
      @reporters = opts
      _require_reporter_libraries
    end

    private

    def initialize_defaults
      @trackers          = Hash.new(0)
      @reporting_vars = Hash.new
      @reporters      = { console: nil, logger: 'logger' }
      @persister      = :memory
    end

    def _require_reporter_libraries
      @reporters.each do |name, lib|
        require lib if lib
      end
    end
  end
end
