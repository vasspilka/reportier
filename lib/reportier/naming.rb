module Reportier
  module Naming
    
    def naming(item)
      pluralize(create_string(item))
    end

    private

    def create_string(item)
      return item.gsub(' ', '_') if item.kind_of? String
      item
    end

    def pluralize(string)
      string.pluralize
    rescue NoMethodError
      string + 's'
    end
  end
end
