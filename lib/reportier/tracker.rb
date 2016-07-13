module Reportier
  class Tracker
    attr_reader :reporter, :persister, :started_at, :type

    def self.[](type)
      @current       ||= Hash.new
      @current[type] ||= new(type: type)
    end

    def initialize(opts = {})
      @started_at   = _set_started_at
      @type         = opts[:type]
      @name         = Namer.new.name \
        "#{opts[:name]}#{@type && @type.capitalize}Tracker"
      @reporter     = opts[:reporter]  || Reporter.get
      @persister    = opts[:persister] || Persister.get(@name)
    end

    def add(item)
      (report && clear) unless active?
      return if Reportier::Default::TYPES[@type] == 0
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
      @started_at = _set_started_at
    end

    def name(item)
      Namer.new.name_item(item)
    end

    def expires_at
      @started_at + Reportier::Default::TYPES[@type]
    end

    private

    def _set_started_at
      return DateTime.now if _set_to_now?
      expires_at
    end

    def _set_to_now?
      @started_at.nil? || _long_due?
    end

    def _long_due?
      expires_at < (DateTime.now - Reportier::Default::TYPES[@type])
    end
  end
end
