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
      data.merge! request_context
      data.merge! extract_custom_fields(data)
      data.merge! runtimes(event)
      data.merge!(
        {
          name: event.name,
          time: event.time,
          transaction_id: event.transaction_id,
          end: event.end,
        }
      )
      ::LogStash::Event.new(data.merge(source: ::LogStasher.source))
    end

    def runtimes(event)
      if event.duration
        { duration: event.duration.to_f.round(2) }
      else
        {}
      end
    end


    def request_context
      ::LogStasher.request_context
    end

    def extract_custom_fields(data)
      custom_fields = (!::LogStasher.custom_fields.empty? && data.extract!(*::LogStasher.custom_fields)) || {}
      ::LogStasher.custom_fields.clear
      custom_fields
    end

  end
end

::LoggerInstrumentation::LogStasherLogSubscriber.attach_to ::LoggerInstrumentation.notification_name
