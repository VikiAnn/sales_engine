gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'time'
file_pattern = File.expand_path "../../lib/*.rb" , __FILE__

Dir[file_pattern].each { |file| require file }
