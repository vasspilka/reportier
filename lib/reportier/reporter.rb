module Reportier
  class Reporter
    attr_accessor :reporters

    def self.get
      @current ||= new(Default::REPORTERS)
    end

    def initialize(reporters)
      @reporters = reporters
    end

    def call(tracker, &blk)
      @reporters.each do |reporter, v|
        eval "to_#{name(reporter)} \"#{blk.call}\""
      end
    end

    private

    def name(item)
      Namer.new.send(:secure, item.to_s)
    end

    def to_console(message)
      puts message
    end

    def to_slack(message)
      type = message.split.first + '_tracker'
      # SlackReporter.new(type).call do
      #   message
      # end
    end

    def to_twilio

    end
  end
end
