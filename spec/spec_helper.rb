$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'logger_instrumentation'

require 'active_support/notifications'
require 'active_support/core_ext/string'
require 'active_support/log_subscriber'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/date_time/calculations'
