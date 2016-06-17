module Reportier
  module Time
    def seconds(int)
      int
    end

    def minutes(int)
      int * 60
    end

    def hours(int)
      minutes(int) * 60
    end

    def days(int)
      hours(int) * 24
    end

    def weeks(int)
      days(int) * 7
    end

    def months(int)
      days(int) * 30
    end

    def years(int)
      months(int) * 12
    end
  end
end
