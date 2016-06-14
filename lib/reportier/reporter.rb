module Reportier
  class Reporter
    def self.get
      @current ||= new(Default::REPORTERS)
    end

    attr_accessor :reporters

    def initialize(reporters)
      @reporters = reporters
    end

    def call(&blk)
      @reporters.each do |reporter, v|
        eval "to_#{name(reporter)} \"#{blk.call}\""
      end
    end

    private

    def name(item)
      Namer.new.send(:secure, item)
    end

    def to_console(message)
      puts message
    end

    def to_slack(message)
      # SlackReporter.new.call do
      #   message
      # end
    end

    def to_twilio

    end
  end
end
