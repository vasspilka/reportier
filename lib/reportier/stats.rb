module Reportier

  class Instant
    attr_accessor :reporter, :persister

    def self.get
      @current ||= new
    end

    def initialize(opts = {})
      @report_type  = self.class.to_s.sub('Reportier::','')
      @started_at   = DateTime.now
      @reporter     = opts[:reporter]  || Reporter.get
      @persister    = opts[:persister] || Persister.get
    end

    def add(item)
      (report && clear) unless active?
      item_name = name(item)
      @persister.save(item_name)
      item_added
    end

    def report
      @reporter.call(self) do
        "#{@report_type} report started at #{@started_at}\n" +
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

    def item_added
      "item added"
    end

    def name(item)
      Namer.new.name_item(item)
    end

    def expires_at
      @started_at
    end
  end
end
