require_relative 'models/world.rb'

class Parser
  def initialize(path)
    @path = path
    @file = File.open(@path)
  end

  def read_products
    @file.readline # Skip products count

    @world.products = @file.readline.split(' ').map(&:to_i)
  end

  def read_warehouses
    warehouses_count = @file.readline.to_i

    warehouses_count.times do |id|
      head = @file.readline.split(' ')

      warehouse = Warehouse.new(id, head)
      warehouse.remains = @file.readline.split(' ').map(&:to_i)

      @world.warehouses << warehouse
    end
  end

  def read_orders
    orders_count = @file.readline.to_i

    orders_count.times do |id|
      head = @file.readline.split(' ')

      order = Order.new(id, head)

      @file.readline # Skip line_items count

      order.line_items = @file.readline.split(' ').map(&:to_i)

      @world.orders << order
    end
  end

  def build
    head = @file.readline.split(' ')

    @world = World.new(head)

    read_products

    read_warehouses

    read_orders

    @world.initialize_drones

    @world
  end
end
