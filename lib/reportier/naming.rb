module Reportier
  module Naming
    
    def naming(item)
      pluralize(create_string(item))
    end

    private

    def create_string(item)
      return secure(item) if item.kind_of? String
      item
    end

    def secure(string)
      string.gsub(';', '_').gsub(' ', '_')
    end

    def pluralize(string)
      string.pluralize
    rescue NoMethodError
      string + 's'
    end
  end
end
