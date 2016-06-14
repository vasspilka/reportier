module Reportier
  class Tracker

    def self.get
      @current ||= new
    end

    def self.add_to_all(item)
      Types::TYPES.each do |type, v|
        eval "#{type}.get.add(item)"
      end
      item_added
    end

    def initialize
      @report_type  = self.class.to_s.sub('Reportier::','')
      @started_at   = DateTime.now
      _initialize_default_reporting_vars
    end

    def add(item)
      (report && clear) unless active?
      item_name = name(item)
      create_accessor(item_name) unless (eval "@#{item_name}")
      eval "@#{item_name} += 1"
      item_added
    end

    def report
      puts "#{@report_type} report started at #{@started_at}\n" +
        attr_messages.inject(&:+).to_s
      return true
    end

    def to_json
      "{#{to_hash.map { |k,v|  "\"#{k.to_s}\": #{v.to_s}"  }.flatten.join(",\n")}}"
    end

    def to_hash
      Hash[ *reporting_vars.collect { |v| [ v.to_s, (eval v.to_s) ] }.flatten ]
    end

    def active?
      DateTime.now < expires_at
    end

    private

    def item_added
      "item added"
    end

    def name(item)
      Namer.new.name_item(item)
    end

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

    def _initialize_default_reporting_vars
      Default::REPORTING_VARS.each do |key, val|
        raise TypeError unless value.kind_of? Integer
        eval "@#{name(key)} = #{val}"
      end
    end
  end
end
