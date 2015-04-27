require 'spec_helper'
require 'logger_instrumentation/log_subscriber'

describe LoggerInstrumentation::LogSubscriber do
  let(:subscriber) { LoggerInstrumentation::LogSubscriber.new }

  let(:message) { "hello world" }
  let(:format) { '\#{payload[:message]} here I am' }
  let(:event) { ActiveSupport::Notifications::Event.new("info.fidor_application", Time.now, Time.now, 2, Hash.new) }
  let(:severity) { :info }
  let(:logger) { double(Logger) }

  before do
    allow(subscriber).to receive(:logger).and_return(logger)
    allow(logger).to receive(:<<).and_return(nil)
  end

  it "passes message to attached logger" do
    event.payload[:message] = message
    expect(subscriber.logger).to receive(severity).with("hello world")
    subscriber.method(severity).call(event)
  end

  it "passes formated message to attached logger when format given" do
    pending
    event.payload[:message] = message
    event.payload[:format] = format
    expect(subscriber.logger).to receive(severity).with("hello world here I am")
    subscriber.method(severity).call(event)
  end

  it "passes string hash to attached logger when hash given" do
    event.payload[:text] = message
    expect(subscriber.logger).to receive(severity).with(event.payload.to_s)
    subscriber.method(severity).call(event)
  end
end
