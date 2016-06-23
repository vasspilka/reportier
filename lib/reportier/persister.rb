module Reportier
  class Persister
    def self.get
      eval "#{Namer.new.name_class(Default::PERSISTER)}Persister.new"
    end

    def initialize
      @reporting_vars = {}
      _initialize_default_reporting_vars
    end

    def save(item)
      item = item.to_sym
      initialize_reporting_var(item) unless @reporting_vars[item]
      @reporting_vars[item] += 1
    end

    def report
      attr_messages.inject(&:+).to_s
    end

    def to_json
      "{#{to_hash.map { |k,v| "\"#{k}\": #{v}" }.flatten.join(",\n")}}"
    end

    def clear
      initialize
    end

    private

    def attr_messages
      @reporting_vars.map do |key, val|
        "#{key}: #{val}\n"
      end
    end
    
    def initialize_reporting_var(name)
      @reporting_vars[name] = 0
    end

    def to_hash
      @reporting_vars
    end

    def _initialize_default_reporting_vars
      Default::REPORTING_VARS.each do |key, val|
        raise TypeError unless val.kind_of? Integer
        @reporting_vars[key] = val
      end
    end
  end
  class MemoryPersister < Persister; end
  class RedisPersister  < Persister

  end
end


