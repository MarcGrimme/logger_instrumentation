require 'rails/railtie'
require 'active_support/log_subscriber'

module LoggerInstrumentation
  class Railtie < Rails::Railtie
    config.logger_instrumentation = ::ActiveSupport::OrderedOptions.new
    config.logger_instrumentation.enabled = false

    initializer :logger_instrumentation, :before => :load_config_initializers do |app|
      LoggerInstrumentation.setup(app) if app.config.logger_instrumentation.enabled
    end
  end
end
