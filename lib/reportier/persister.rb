module Reportier
  class Persister
    def self.get(tracker)
      eval "#{Namer.new.name_class(Default::PERSISTER)}" \
      + "Persister.new('#{tracker}')"
    end

    def initialize(tracker)
      @tracker = tracker
      @reporting_vars = {}
      _initialize_default_reporting_vars
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
      initialize
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

    def _initialize_default_reporting_vars
      Default::REPORTING_VARS.each do |key, val|
        raise TypeError unless val.kind_of? Integer
        @reporting_vars[key] = val
      end
    end
  end
  class MemoryPersister < Persister; end
  class RedisPersister  < Persister
    private

    def to_hash
      Hash[reporting_vars.map { |k| [k, get(k)] }]
    end

    def incr(item)
      Redis.current.incr "#{@tracker}:#{item}"
    end

    def set(item, val)
      Redis.current.set "#{@tracker}:#{item}", val
    end

    def get(item)
      Redis.current.get "#{@tracker}:#{item}"
    end

    def reporting_vars
      Redis.current.keys("#{@tracker}:*").map do |var|
        var.sub("#{@tracker}:",'')
      end
    end

    def clear
      Redis.current.del(Redis.current.keys("#{@tracker}:*"))
    rescue Redis::CommandError
    end
  end
end


