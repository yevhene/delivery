class Drone
  attr_accessor :world, :id

  attr_accessor :time, :row, :column

  attr_accessor :instructions

  def initialize(world, id, time, row, column)
    @world = world
    @id = id
    @time = time
    @row = row
    @column = column
    @instructions = []
  end

  def find_warehouse(product_id)
    warehouse = @world.warehouses.find do |warehouse|
      warehouse.remains[product_id] > 0
    end

    warehouse.remains[product_id] -= 1

    warehouse
  end

  def fly_to(r1, c1)
    @time += Math.sqrt((r1 - @row) ** 2 + (c1 - @column) ** 2).ceil
    @row = r1
    @column = c1
  end

  def load(warehouse, product_id)
    @instructions << "#{id} L #{warehouse.id} #{product_id} 1"
    fly_to(warehouse.row, warehouse.column)
    @time += 1
  end

  def deliver(order, product_id)
    @instructions << "#{id} D #{order.id} #{product_id} 1"
    fly_to(order.row, order.column)
    @time += 1
  end

  def service(order)
    order.line_items.each do |line_item|
      warehouse = find_warehouse(line_item)
      load(warehouse, line_item)
      deliver(order, line_item)
    end
  end
end