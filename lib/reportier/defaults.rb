module Reportier

  TYPES          = Hash.new(0)
  REPORTERS      = Hash.new
  PERSISTER      = :memory

  def self.set_default_types(opts={})
    TYPES.merge!(opts)
  end

  def self.set_default_reporters(opts={})
    REPORTERS.merge!(opts) 
    _require_reporter_libraries
  end

  private

  def self._require_reporter_libraries
    REPORTERS.each do |name, lib|
      require lib if lib
    end
  end

  class Defaults
    attr_reader :reporting_vars

    def initialize
      @reporting_vars = Hash.new
    end

    def replace_defaults(hash)
      @reporting_vars = hash
    end

    def update_defaults(hash)
      @reporting_vars.merge!(hash)
    end
  end
end
