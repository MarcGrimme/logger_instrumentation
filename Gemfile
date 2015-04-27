source 'https://rubygems.org'

# Specify your gem's dependencies in logger_instrumentation.gemspec
gemspec

gem 'rails', "~> #{ENV["RAILS_VERSION"] || "3.2.0"}"
   
group :test do
  gem 'rcov', :platforms => :mri_18
  gem 'simplecov', :platforms => :mri_19, :require => false
  gem 'pry'
  gem 'pry-byebug'
end
