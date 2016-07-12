require          'date'
require_relative 'reportier/naming'
require_relative 'reportier/time'
require_relative 'reportier/reporter'
require_relative 'reportier/persister'
require_relative 'reportier/tracker'
require_relative 'reportier/defaults'
require_relative 'reportier/version'

module Reportier
  def self.add_to_all(item)
    Default::TYPES.each do |type, v|
      Tracker[type].add(item)
    end
  end
end
