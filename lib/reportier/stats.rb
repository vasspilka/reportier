module Reportier

  class Tracker
    include Naming

    def self.get
      @current ||= new
    end

    def self.add_to_all(item)
      Types::TYPES.each do |type, v|
        eval "#{type}.get.add(item) if #{type}.get.active?"
      end
      "ok"
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
      "ok"
    end

    def report
      puts "#{@report_type} report started at #{@started_at}\n" +
           attr_messages.inject(&:+)
    end

    def to_json
      to_hash.to_json
    end

    def active?
      DateTime.now < expires_at
    end

    private

    def clear
      reporting_vars.each do |var|
        eval "#{var} = 0"
      end
      initialize
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
      @started_at
    end

    def to_hash
      Hash[ *reporting_vars.collect { |v| [ v.to_s, (eval v.to_s) ] }.flatten ]
    end
  end

  Types::TYPES.each do |key, value|
    raise TypeError unless value.kind_of? Integer
    eval %{
    class #{key} < Tracker
      def expires_at
        @started_at + #{value}
      end
    end
    }
  end
end
