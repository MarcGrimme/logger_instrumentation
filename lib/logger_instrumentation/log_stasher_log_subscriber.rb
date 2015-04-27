require 'active_support/log_subscriber'
require 'logstash-event'
require 'logstasher'

module LoggerInstrumentation
  class LogStasherLogSubscriber < ::ActiveSupport::LogSubscriber
    def initialize
      super
    end

    %w( fatal error warn info debug unknown ).each do |severity|
      eval <<-EOM, nil, __FILE__, __LINE__ + 1
        def #{severity}(event)
          logger << convert(event).to_json + "\n"
        end
      EOM
    end

    def logger
      ::LogStasher.logger
    end

    def convert(event)
      data = event.payload
      data.merge!(
        {
          name: event.name,
          time: event.time,
          transaction_id: event.transaction_id,
          end: event.end,
          duration: event.duration,
        }
      )
      ::LogStash::Event.new(data.merge(source: ::LogStasher.source))
    end
  end
end

::LoggerInstrumentation::LogStasherLogSubscriber.attach_to ::LoggerInstrumentation.notification_name
