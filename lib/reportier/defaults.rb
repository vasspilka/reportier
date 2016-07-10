module Reportier
  module Default
    extend Time

    TYPES = {
      :hourly   => hours(1),
      :daily    => days(1),
      :weekly   => weeks(1),
      :monthly  => months(1)
    }

    REPORTING_VARS = {}

    REPORTERS = {
     console: nil
    }

    PERSISTER = :memory

  end

  def self.set_default_reporting_vars(opts={})
    Default::REPORTING_VARS.merge!(opts)
  end

  def self.set_default_types(opts={})
    Default::TYPES.merge!(opts)
    _default_classes_create
  end

  def self.set_default_reporters(opts={})
    Default::REPORTERS.merge!(opts) 
    _require_reporter_libraries
  end

  private

  def self._require_reporter_libraries
    Default::REPORTERS.each do |name, lib|
      require lib if lib
    end
  end
end
