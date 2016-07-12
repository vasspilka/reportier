module Reportier
  class Tracker
    attr_reader :reporter, :persister

    def self.[](type)
      @current       ||= Hash.new
      @current[type] ||= new(type: type)
    end

    def initialize(opts = {})
      @started_at   = _set_started_at
      @type         = opts[:type] || :instant
      @name         = Namer.new.name \
        "#{opts[:name]}#{@type.capitalize}Tracker"
      @reporter     = opts[:reporter]  || Reporter.get
      @persister    = opts[:persister] || Persister.get(@name)
    end

    def add(item)
      (report && clear) unless active?
      @persister.save(name(item))
    end

    def report
      @reporter.call(self) do
        "#{@type} report started at #{@started_at}\n" +
        @persister.report
      end
    end

    def to_json
      @persister.to_json
    end

    def active?
      DateTime.now < expires_at
    end

    private

    def clear
      @persister.clear
    end

    def name(item)
      Namer.new.name_item(item)
    end

    def expires_at
      return 0 unless Reportier::Default::TYPES[@type]
      @started_at +   Reportier::Default::TYPES[@type]
    end

    private

    def _set_started_at
      return DateTime.now if _set_to_now?
      expires_at
    end

    def _set_to_now?
      (@started_at == nil) || long_due?
    end

    def _long_due?
      expires_at < (DateTime.now - Reportier::Default::TYPES[@type])
    end
  end
end
