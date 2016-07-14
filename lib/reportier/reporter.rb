module Reportier
  class Reporter
    attr_accessor :reporters

    def self.get
      @current ||= new(Defaults.global.reporters)
    end

    def initialize(reporters)
      @reporters = reporters
    end

    def call(tracker, &blk)
      @reporters.each do |reporter, v|
        eval "to_#{Namer.new.name(reporter)} \"#{blk.call}\""
      end
    end

    private

    def to_console(message)
      puts message
    end

    def to_slack(message)
      type = message.split.first + '_tracker'
      SlackReporter.new(type).call do
        message
      end
    end

    def to_logger(message)
      create_dir('log') unless Dir.exists? 'log'
      Logger.new('log/reportier.log').info("\n" + message)
    end

    def to_twilio

    end

    private

    def create_dir(dir)
      require 'fileutils'
      FileUtils.mkdir_p dir
    end
  end
end
