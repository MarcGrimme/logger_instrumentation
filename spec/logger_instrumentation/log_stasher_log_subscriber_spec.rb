require 'spec_helper'
require 'logger'
require 'logger_instrumentation/log_stasher_log_subscriber'

describe LoggerInstrumentation::LogStasherLogSubscriber do
  let(:subscriber) { LoggerInstrumentation::LogStasherLogSubscriber.new }

  let(:message) { "hello world" }
  let(:format) { '\#{payload[:message]} here I am' }
  let(:start_ts) { 2.minutes.ago }
  let(:end_ts) { Time.now }
  let(:event) { ActiveSupport::Notifications::Event.new("info.fidor_application", start_ts, end_ts, 2, Hash.new) }
  let(:severity) { :info }
  let(:logger) { double(Logger) }
  let(:result_hash) do {
    name: 'info.fidor_application', 
    time: start_ts, 
    transaction_id: 2, 
    end: end_ts,
    duration: 1000.0 * (end_ts - start_ts),
    source: "unknown"
  }
  end

  before do
    allow(subscriber).to receive(:logger).and_return(logger)
    allow(logger).to receive(:<<).and_return(nil)
  end

  it "passes message to attached logger" do
    event.payload[:message] = message
    expect(LogStash::Event).to receive(:new).with(result_hash.merge({
      message: message,
    }))
    subscriber.method(severity).call(event)
  end

  it "passes formated message to attached logger when format given" do
    event.payload[:message] = message
    event.payload[:format] = format
    expect(LogStash::Event).to receive(:new).with(result_hash.merge({
      message: message,
      format: format
    }))
    subscriber.method(severity).call(event)
  end

  it "passes string hash to attached logger when hash given" do
    event.payload[:text] = message
    expect(LogStash::Event).to receive(:new).with(result_hash.merge({
      text: message,
    }))
    subscriber.method(severity).call(event)
  end
end
