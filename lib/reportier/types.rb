module Reportier
  module Types
    extend Time

    TYPES = {
      'Instant' => 0,
      'Hourly'  => hours(1),
      'Daily'   => days(1),
      'Weekly'  => weeks(1),
      'Monthly' => months(1)
    }

  end
end
