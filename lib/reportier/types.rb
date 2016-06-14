module Reportier
  module Default
    extend Time

    TYPES = {
      'Hourly'  => hours(1),
      'Daily'   => days(1),
      'Weekly'  => weeks(1),
      'Monthly' => months(1)
    }

    REPORTING_VARS = {}

  end

  def self.set_default_reporting_vars(opts={})
    Default::REPORTING_VARS.merge!(opts)
  end

  def self.set_default_types(opts={})
    Default::TYPES.merge!(opts)
    _default_classes_create
  end

  private

  def self._default_classes_create
    Default::TYPES.each do |key, val|
      raise TypeError unless val.kind_of? Integer
      s_key = Namer.new.name_class(key)
      eval %{
      class #{s_key} < Tracker
        def expires_at
          @started_at + #{val}
        end
      end
      }
    end
  end
  _default_classes_create
end
