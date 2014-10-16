require 'bundler/setup'
Bundler.require(:default, :test)
require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require 'time'
file_pattern = File.expand_path "../../lib/*.rb" , __FILE__

Dir[file_pattern].each { |file| require file }
