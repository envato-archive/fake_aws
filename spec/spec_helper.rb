$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'fake_aws'
require 'rack'

Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

