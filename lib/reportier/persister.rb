module Reportier
  class Persister
    def self.get
      @current ||= eval "#{Namer.new.name_class(Default::PERSISTER)}Persister.new"
    end

    def initialize
      _initialize_default_reporting_vars
    end

    def save(item)
      create_accessor(item) unless (eval "@#{item}")
      eval "@#{item} += 1"
    end

    def report
      attr_messages.inject(&:+).to_s
    end

    def to_json
      "{#{to_hash.map { |k,v| "\"#{k.to_s}\": #{v.to_s}" }.flatten.join(",\n")}}"
    end

    private

    def attr_messages
      reporting_vars.map do |var|
        "#{var}: #{eval var.to_s}\n"
      end
    end
    
    def create_accessor(name)
      self.class.module_eval "attr_accessor :#{name}"
      eval "@#{name} ||= 0"
    end

    def to_hash
      Hash[ *reporting_vars.collect { |v| [ v.to_s, (eval v.to_s) ] }.flatten ]
    end

    def reporting_vars
      instance_variables
    end

    def clear
      reporting_vars.each do |var|
        eval "#{var} = 0"
      end
      initialize
    end

    def _initialize_default_reporting_vars
      Default::REPORTING_VARS.each do |key, val|
        raise TypeError unless value.kind_of? Integer
        eval "@#{Name.new.name(key)} = #{val}"
      end
    end
  end
  class MemoryPersister < Persister; end
  class RedisPersister  < Persister

  end
end


