#!/home/yevhene/.rvm/rubies/ruby-2.3.0/bin/ruby

require_relative 'parser.rb'

WORLD = Parser.new(ARGV[0]).build

WORLD.run

name = File.basename(ARGV[0], '.in')

File.open("output/#{name}.out", 'w') do |file|
  instructions = WORLD.instructions
  file.write(instructions.length.to_s + "\n")

  instructions.each do |instruction|
    file.write(instruction + "\n")
  end
end

times = WORLD.drones.map(&:time)

puts "[#{times.min}, #{times.max}]"
