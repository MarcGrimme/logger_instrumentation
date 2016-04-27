# LoggerInstrumentation

I've seen so many Rails applications using Rails.logger.debug|info|warn|error all around the place. This is ok as long as you use the normal 
Rails logging infrastructure (which is logging to a discrete file). But if you would like to use it in a way that multiple log files are used
or the logs are converted to log data (like logstash or whatever other format) then you are pretty much busted.

To work around this Rails itself uses ActiveSupport::Notifications. Nevertheless many of the developers don't wont to bother with this but use
an API as mentioned above.

To fill that gap I created a gem that allows the developer to do something like
```ruby
LoggerInstrumenation.info("mylog message")
```
or
```ruby
LoggerInstrumentation.info({message: "mylog message", otherdata: "this is other data"})
```
This will automatically as always create the proper log entries in the specified log file but uses ActiveSupport::Notifications in the background
and by this supports multiple ActiveSupport::LogSubscribers with different log handling (like for example [logstash](http://www.logstash.net)).

I made an example implementation for [LogStasher](https://github.com/shadabahmed/logstasher) so that the logs can benifit from the additional information supported by LogStasher like the
``resource_context`` or others.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'logger_instrumentation'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logger_instrumentation

## Usage

So if you are convinced this gem helps you, you can easily use it in your Rails app as follows.

### Installation setup above

Follow Installation above

### Create an initializer to setup your environment

If you are using the logstasher gem too then proceed as follows (TODO: for having setup logstash as ``logstasher.supress_app_log``):
*config/initializers/logger_instrumenation.rb*
```ruby
if Module.const_defined?('LoggerInstrumentation') && LoggerInstrumentation.enabled?
  if Module.const_defined?('LogStasher') and LogStasher.enabled?
    require 'logger_instrumentation/log_stasher_log_subscriber'
  end
  require 'logger_instrumentation/log_subscriber'
  LoggerInstrumentation.logger = Rails.logger
end
```
Then enable for your environment (like development here):
*config/environments/development.rb*
```
..
config.logger_instrumentation.enabled = true
```

Now whereever you would normally use ``Rails.logger.info`` or ``Rail.logger.debug`` or friends just use/replace with 
``LoggerInstrumenation::Instrumentation.info`` or ``LoggerInstrumenation::Instrumentation.debug`` or whatever log level you intend to use.

```ruby
LoggerInstrumenation::Instrumentation.info('hello world.')
```

It's also instead of just a string possible to pass a ``Hash`` to this method. For something like logstash it will just convert the ``Hash`` to ``JSON``. For the
normal logger it will execute the ``to_s`` method.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/marcgrimme/logger_instrumentation/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
