# Reportier the stat tracker

This is a tracker that tracks the count of events.

## Use
`gem 'reportier'`

Using the Tracker is fairly simple, by default there are 4 types of trackers.
An `Hourly`, a `Daily` a `Weekly` and a `Monthly`.
To add something to a tracker simply `.get` it and `#add` something.

You can also `#report` the current state of the tracker, however trackers report and reset by themselves
as long as you keep adding items to them.

Examples:

```
Reportier::Daily.get.add('new user registration')

Reportier::Daily.get.report
# -> Daily report started at 2016-06-17T15:34:40+03:00
# @new_user_registrations: 1
```

You can also use `Reportier.add_to_all('we need to track this')` and it will add the item to all trackers.
If you keep adding this way, each tracker will report when his time is due, and you have to worry about
nothing else.

Trackers also have a `#to_json` method for converting tracked items to json.


## Setting defaults

Reportier has 3 methods for setting defaults.

`.set_default_reporting_vars`

This is for setting default things you want to track. Example use would be.

```
Reportier.set_default_reporting_vars active_users: User.active, open_conversations: Conversation.all.count
```

`.set_default_types`

This is for setting default tracker types, by type we mean how much time it needs for reset.
So the usage would be


```
Reportier.set_default_types 'Yearly' => 1.year, 'BiDay' => 2.days
```

These new tracker classes will be created and can be used normally like any other tracker,
also `Reportier.add_to_all` will take this new classes in account.
Note that if you don't use Rails you can `import` or `extend` `Reportier::Time` to you current environment
and use `hours(1)`, `days(1)`, `weeks(1)`,  `months(1)`, `years(1)`, years and months are not exact.

`.set_default_reporters`

This is for setting default reporters, by default Reportier will only report to console
but we also support reporting to slack and logger, and you can easily create your custom reporting methods.

```
Reportier.set_default_reporters slack: 'slack-reporter', logger: 'logger'
```

If you want to add custom reporters just add their name and library and then define a `to_#{name)` method to the `Reporter`
e.x.

```
Reportier.set_default_reporters twilio: 'twilio-ruby'

class Reportier::Reporter
  def to_twilio
    ## you code here
  end
end
```


## More

There are many more features to come, as persiters.
This has been kind of a personal project, please give me feedback on anything that has room for improvement.


This gem is not tested and could be unsafe for production environment


## TODO

Change from instance variables to hash for memory persistance... damn this is silly

Defaults per type or tracker

Redis persister


