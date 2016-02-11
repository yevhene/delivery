class Drone
  attr_accessor :world, :id

  attr_accessor :time, :row, :column

  attr_accessor :current_weight, :current_cargo

  attr_accessor :instructions

  def initialize(world, id, time, row, column)
    @world = world
    @id = id
    @time = time
    @row = row
    @column = column

    @current_weight = 0
    @current_cargo = []

    @instructions = []
  end

  def find_warehouse(product_id)
    warehouses = @world.warehouses.select do |warehouse|
      warehouse.remains[product_id] > 0
    end

    distances = warehouses.map do |warehouse|
      distance(warehouse.row, warehouse.column)
    end

    index = distances.index(distances.min)

    warehouses[index]
  end

  def distance(r1, c1)
    Math.sqrt((r1 - @row) ** 2 + (c1 - @column) ** 2).ceil
  end

  def fly_to(r1, c1)
    @time += distance(r1, c1)
    @row = r1
    @column = c1
  end

  def load(warehouse, product_id, count = 1)
    @instructions << "#{id} L #{warehouse.id} #{product_id} #{count}"
    warehouse.remains[product_id] -= count
    fly_to(warehouse.row, warehouse.column)
    @time += 1
  end

  def deliver(order, product_id, count = 1)
    @instructions << "#{id} D #{order.id} #{product_id} #{count}"
    fly_to(order.row, order.column)
    @time += 1
  end

  def can_carry?(product_id)
    (@current_weight + @world.products[product_id]) <= @world.max_drone_load
  end

  def load_all(order, warehouse)
    line_items = order.line_items.clone.reverse

    line_items.each_with_index do |line_item, index|
      if warehouse.remains[line_item] > 0 && can_carry?(line_item)
        load(warehouse, line_item)
        @current_weight += @world.products[line_item]
        order.line_items.slice!(line_items.length - index - 1)
        @current_cargo << line_item
      end
    end
  end

  def deliver_all(order)
    @current_cargo.each do |line_item|
      deliver(order, line_item)
    end

    @current_cargo = []
    @current_weight = 0
  end

  def service(order)
    while order.line_items.length > 0
      warehouse = find_warehouse(order.line_items.last)
      load_all(order, warehouse)
      deliver_all(order)
    end
  end
end
