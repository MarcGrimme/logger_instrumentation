require 'spec_helper'

describe LoggerInstrumentation do
  it 'has a version number' do
    expect(LoggerInstrumentation::VERSION).not_to be nil
  end

  it 'has a notification_name' do
    expect(LoggerInstrumentation.notification_name).to eq "logger_instrumentation"
  end

  it 'is disabled by default' do
    expect(LoggerInstrumentation.enabled?).to be false
  end
end
