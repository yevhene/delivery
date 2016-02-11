require_relative 'warehouse.rb'
require_relative 'order.rb'
require_relative 'drone.rb'

class World
  attr_accessor :rows_count, :columns_count, :drones_count,
                :deadline, :max_drone_load

  attr_accessor :products, :warehouses, :orders

  attr_accessor :drones

  def initialize(options)
    @rows_count = options[0].to_i
    @columns_count = options[1].to_i
    @drones_count = options[2].to_i
    @deadline = options[3].to_i
    @max_drone_load = options[4].to_i

    @products = []
    @warehouses = []
    @orders = []

    @drones = []
  end

  def initialize_drones
    @drones_count.times do |i|
      @drones << Drone.new(self, i, 0,
                           @warehouses[0].row, @warehouses[0].column)
    end
  end

  def free_drone
    times = @drones.map(&:time)
    index = times.index(times.min)
    @drones[index]
  end

  def run
    @orders.each do |order|
      free_drone.service(order)
    end
  end

  def instructions
    @drones.map do |drone|
      drone.instructions
    end.flatten
  end
end
