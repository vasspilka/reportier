module Reportier
  class Persister

    def self.get(tracker, persister_type = Defaults.global.persister)
      type = Namer.new.name_class(persister_type)
      persister = eval "#{type}Persister"
      persister.new(tracker)
    end

    attr_reader :reporting_vars

    def initialize(tracker)
      @tracker = tracker
      @defaults = tracker.defaults
      @reporting_vars = {}
      _initialize_reporting_vars
    end

    def save(item)
      item = item.to_sym
      initialize_reporting_var(item) unless get(item)
      incr(item)
    end

    def report
      attr_messages.inject(&:+).to_s
    end

    def to_json
      "{#{to_hash.map { |k,v| "\"#{k}\": #{v}" }.flatten.join(",\n")}}"
    end

    def clear
      initialize @tracker
    end

    private

    def incr(item)
      @reporting_vars[item] += 1
    end

    def get(item)
      @reporting_vars[item]
    end

    def set(item, val)
      @reporting_vars[item] = 0
    end

    def attr_messages
      to_hash.map do |key, val|
        "#{key}: #{val}\n"
      end
    end
    
    def initialize_reporting_var(name)
      set(name, 0)
    end

    def to_hash
      @reporting_vars
    end

    def _initialize_reporting_vars
      @reporting_vars.merge!(@defaults.reporting_vars)
    end
  end
  class MemoryPersister < Persister; end
  class RedisPersister  < Persister

    def reporting_vars
      Redis.current.keys(name + '*').map do |var|
        var.sub(name,'')
      end
    end

    def clear
      Redis.current.del(Redis.current.keys(name))
    rescue Redis::CommandError
    end

    private

    def to_hash
      Hash[reporting_vars.map { |k| [k, get(k)] }]
    end

    def incr(item)
      Redis.current.incr name(item)
    end

    def set(item, val)
      Redis.current.set name(item), val
    end

    def get(item)
      Redis.current.get name(item)
    end
    
    def name(item=nil)
      "#{@tracker.name}:#{item}"
    end
  end
end


