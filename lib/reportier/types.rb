module Reportier
  extend Naming
  module Types
    extend Time

    TYPES = {
      'Hourly'  => hours(1),
      'Daily'   => days(1),
      'Weekly'  => weeks(1),
      'Monthly' => months(1)
    }
  end

  def self.set_default_types(opts={})
    Reportier::Types::TYPES.merge!(opts)
    _default_classes_create
  end

  private

  def self._default_classes_create
    Types::TYPES.each do |key, value|
      raise TypeError unless value.kind_of? Integer
      eval %{
      class #{secure(key)} < Tracker
        def expires_at
          @started_at + #{value}
        end
      end
      }
    end
  end
  _default_classes_create
end
