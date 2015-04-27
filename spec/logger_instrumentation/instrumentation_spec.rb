require 'spec_helper'
require 'logger_instrumentation/instrumentation'

describe LoggerInstrumentation::Instrumentation do
  let(:message) { 'Hello world' }
  let(:message_hash) {
    { message: message, format: 'the format #{payload[:message]}' }
  }
  let(:severity) { :info }

  it "log calls ActiveSupport::Notifications.instrument with message" do
    expect(ActiveSupport::Notifications).to receive(:instrument).with("#{severity}.#{LoggerInstrumentation.notification_name}", {message: message})
    expect(LoggerInstrumentation::Instrumentation.method(severity).call(message)).to eq(true)
  end

  it "log calls ActiveSupport::Notifications.instrument with Hash" do
    expect(ActiveSupport::Notifications).to receive(:instrument).with("#{severity}.#{LoggerInstrumentation.notification_name}", message_hash)
    expect(LoggerInstrumentation::Instrumentation.method(severity).call(message_hash)).to eq(true)
  end
end
