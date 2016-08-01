module Reportier
  class Tracker
    attr_accessor :started_at
    attr_reader :reporter, :persister, :type, :name, :defaults
      

    def self.[](type)
      @current       ||= Hash.new
      @current[type] ||= new(type: type)
    end

    def initialize(opts = {})
      @type         = opts[:type]
      @name         = Namer.new.name \
        "#{opts[:name]}#{@type && @type.capitalize}Tracker"
      @defaults     = Defaults.global
      @reporter     = opts[:reporter]  || Reporter.get
      @persister    = opts[:persister] || Persister.get(self)
      @persister.set_date(_set_date)
    end

    def add(item)
      (report && clear) unless active?
      return if Defaults.global.trackers[@type] == 0
      @persister.save(Namer.new.name_item(item))
    end

    def report
      @reporter.call(self) do
        "#{@type} report started at #{@started_at}\n" +
        @persister.report
      end
    end

    def active?
      DateTime.now < expires_at
    end

    def to_json
      @persister.to_json
    end

    def to_hash
      @persister.to_hash
    end

    private

    def clear
      @persister.clear
      @persister.set_date(_set_date)
    end

    def expires_at
      get_date + Defaults.global.trackers[@type]
    end

    def get_date
      @persister.get_date
    end

    private

    def _set_date
      return DateTime.now if _set_to_now?
      active? ? get_date : expires_at
    end

    def _set_to_now?
      get_date.nil? || _long_due?
    end

    def _long_due?
      expires_at < (DateTime.now - Defaults.global.trackers[@type])
    end
  end
end
