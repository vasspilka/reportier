module Reportier

  class Tracker
    include Naming
    include Time
    def self.get
      @current ||= new
    end

    def self.add_to_all(item)
      Daily .get.add(item)
      Weekly.get.add(item)
    end

    def initialize
      @report_type  = self.class.to_s.sub('Stats','')
      @started_at   = DateTime.now
    end

    def add(item)
      (report && clear) unless active?
      item_name = naming(item)
      create_accessor(item_name)
      eval "@#{item_name} += 1"
    end

    def report
      puts "#{@report_type} report started at #{@started_at}\n" +
           attr_messages.inject(&:+)
    end

    def to_json
      to_hash.to_json
    end

    private

    def clear
      reporting_vars.each do |var|
        eval "#{var} = 0"
      end
      initialize
    end

    def active?
      DateTime.now < expires_at
    end

    def create_accessor(name)
      self.class.module_eval "attr_accessor :#{name}"
      eval "@#{name} ||= 0"
    end

    def attr_messages
      reporting_vars.map do |var|
        "#{var}: #{eval var.to_s}\n"
      end
    end

    def reporting_vars
      instance_variables - [:@report_type, :@started_at]
    end

    def expires_at
      raise StandardError
    end

    def to_hash
      Hash[ *reporting_vars.collect { |v| [ v.to_s, (eval v.to_s) ] }.flatten ]
    end
  end

  class Instant < Tracker
    def expires_at
      @started_at
    end
  end

  class Hourly < Tracker
    def expires_at
      @started_at + hours(1)
    end
  end

  class Daily < Tracker
    def expires_at
      @started_at + days(1)
    end
  end

  class Weekly < Tracker
    def expires_at
      @started_at + weeks(1)
    end
  end
end
