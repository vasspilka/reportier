module Reportier
  class Namer

    def name_class(item)
      create_string(item).capitalize
    end

    def name_item(item)
      pluralize(create_string(item))
    end

    def name(item)
      create_string(item)
    end

    private

    def stringlike?(item)
      item.is_a?(String) || item.is_a?(Symbol)
    end

    def create_string(item)
      return secure(item) if 
      item.class.to_s.downcase
    end

    def secure(string)
      string.to_s.gsub("\n",'_').gsub('\n', '_').gsub(';', '').gsub(' ', '_') \
        .gsub('"', '').gsub('\'','')
    end

    def pluralize(string)
      string.pluralize
    rescue NoMethodError
      string + 's'
    end
  end
end
