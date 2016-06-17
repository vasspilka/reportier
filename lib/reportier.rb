require_relative 'reportier/naming'
require_relative 'reportier/time'
require_relative 'reportier/reporter'
require_relative 'reportier/persister'
require_relative 'reportier/stats'
require_relative 'reportier/defaults'
require_relative 'reportier/version'

module Reportier
  def self.add_to_all(item)
    Default::TYPES.each do |type, v|
      eval "#{type}.get.add(item)"
    end
  end
end
