require 'logger_instrumentation/railtie' if defined?(Rails)
require 'logger_instrumentation/version'
require 'logger_instrumentation/instrumentation'

module LoggerInstrumentation
  extend self

  attr_accessor :enabled, :notification_name, :logger
  @notification_name = "logger_instrumentation"
  @enabled = false

  def enabled?
    self.enabled
  end

  def setup(app)
    self.logger = app.config.logger_instrumentation.logger || nil
    self.notification_name = app.config.logger_instrumentation.notification_name || 'logger_instrumentation'
    self.enabled = true
  end
end
