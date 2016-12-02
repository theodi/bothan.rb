$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bothan'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.default_cassette_options = { :record => :once }
  config.configure_rspec_metadata!
end
