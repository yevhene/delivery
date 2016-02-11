require_relative 'warehouse.rb'
require_relative 'order.rb'

class World
  attr_accessor :rows_count, :columns_count, :drones_count,
                :deadline, :max_drone_load

  attr_accessor :products, :warehouses, :orders

  def initialize(options)
    @rows_count = options[0].to_i
    @columns_count = options[1].to_i
    @drones_count = options[2].to_i
    @deadline = options[3].to_i
    @max_drone_load = options[4].to_i

    @products = []
    @warehouses = []
    @orders = []
  end
end
