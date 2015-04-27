require 'active_support/notifications'
module LoggerInstrumentation
  module Instrumentation
    def self.log(severity, payload)
      if payload.is_a? Hash
        raw_payload = payload.dup
      else
        raw_payload = {
          message: payload,
        }
      end
      ::ActiveSupport::Notifications.instrument("#{severity}.#{LoggerInstrumentation.notification_name}", raw_payload.dup)
      true
    end

    %w( fatal error warn info debug unknown ).each do |severity|
      eval <<-EOM, nil, __FILE__, __LINE__ + 1
        def self.#{severity}(payload)
          self.log(:#{severity}, payload)
        end
      EOM
    end
  end
end
