require 'active_support/log_subscriber'

module LoggerInstrumentation
  class LogSubscriber < ::ActiveSupport::LogSubscriber
    def initialize
      super
    end

    %w( fatal error warn info debug unknown ).each do |severity|
      eval <<-EOM, nil, __FILE__, __LINE__ + 1
        def #{severity}(event)
          super(convert(event))
        end
      EOM
    end

    def logger
      ::LoggerInstrumentation.logger
    end

    protected

    def convert(event)
      if event.payload.has_key? :format
        eval 'payload=event.payload; payload[:format]'
      elsif event.payload.has_key?(:message) && event.payload.size == 1
        event.payload[:message]
      else
        event.payload.to_s
      end
    end
  end
end

::LoggerInstrumentation::LogSubscriber.attach_to ::LoggerInstrumentation.notification_name
