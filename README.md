# Reportier the stat tracker

This is a tracker that tracks the count of events. Most notable is that 
as long as you keep dang items reportier will report automatically
without using 3rd party software like cron.

## Usage

`gem 'reportier'`

Use Reportier to track how many times something happened in a certain amount of time.
Reportier has a minimal public interface however is quite powerful inside.

To use first configure it with intervals by setting a name and when to report

```
Reportier.configure do |c|
  # Time is in seconds
  c.trackers = {
    hourly:   60 * 60,
    bidaily:  60 * 60 * 24 * 2
  }
end
```

Then you can add items to trackers and it will keep track of them.

```
  Reportier[:hourly].add "Home page visit"
  # or
  Reportier[:bidaily].add @newly_registered_user # object of type User
```

Note that you can add objects and Reporiter will track their class.
You can also add the item to all *registered* <sup>[1](#myfootnote1)</sup> trackers by doing 

```
Reportier.add_to_all @item
```

You can manually report or convert it to json.

```
Reportier[:daily].add('new user registration')

Reportier[:daily].report
# -> Daily report started at 2016-06-17T15:34:40+03:00
# new_user_registrations: 1

Reportier[:daily].to_json 
# -> "{\"new_user_registrations\": 1}"
```

Tracker check if they have expired every time an item is added.
And they will reset and report when they relies that they have expired

## Persistence

Reportier saves items to memory by default however we also support long time 
persistence with redis, and maybe postgres in the future.

To use redis look on setting defaults below.

## Setting defaults

### Persister
Right now we only support memory and redis.
Select peristance like so.

```
Reportier.configure do |c|
  c.persister = :redis
end
```

### Reporters

By default Reportier will only report to logger and console
but we also support reporting to slack through slack-reporter,
and you can easily create your custom reporting methods.

```
Reportier.configure do |c|
  c.reporters = { logger: 'logger', slack: 'slack-reporter' }
end

## Note you need to add 'slack-reporter' to your gemfile
```

If you want to add custom reporters just add their name and library and then define a `to_#{name)` method to the `Reporter`
e.x.

```
Reportier.configure { |c| c.reporters = { twilio: 'twilio-ruby' } }

class Reportier::Reporter
  def to_twilio(message)
    ## Do something with #{message}
  end
end
```

### Default reporting vars

Sometimes its useful no have stats from other services or modules.
To do that you can configure reportier to have some default reporting variables

``` 
Reportier.configure do |c|
  # For adding reporting vars
  c.reporting_vars = { active_users: UserRepo.active.count }
  # For updating existing reporting vars
  c.update_reporting_vars {
    todays_messages: Message.where('created_at > ?', Datetime.yesterday)
  }
end
```

### Full configuration

Of course you can you all this in a single configuration in the startup of your
application. A full configuration would look something like this.

```
Reportier.configure do |c|
  c.persister = :redis
  c.trackers  = { daily: 60 * 60 * 24 }
  c.reporters = { logger: 'logger', slack: 'slack-reporter' }
  c.reporting_vars = { active_users: UserRepo.active.count }
end
```

## Custom Trackers
Documentation soon

<a name="myfootnote1">1</a>: 
