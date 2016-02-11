#!/home/yevhene/.rvm/rubies/ruby-2.3.0/bin/ruby

require_relative 'parser.rb'

WORLD = Parser.new(ARGV[0]).build

puts WORLD.orders[0].line_items[4]
