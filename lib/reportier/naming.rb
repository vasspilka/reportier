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

    def create_string(item)
      return secure(item.to_s) if stringy?(item)
      item.class.to_s.downcase
    end

    def secure(string)
      string.gsub("\n",'_').gsub('\n', '_').gsub(';', '').gsub(' ', '_') \
        .gsub('"', '').gsub('\'','')
    end

    def stringy?(item)
      item.is_a?(String) || item.is_a?(Symbol)
    end

    def pluralize(string)
      string.pluralize
    rescue NoMethodError
      string + 's'
    end
  end
end
