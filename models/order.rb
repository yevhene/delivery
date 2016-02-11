class Order
  attr_accessor :id, :row, :column, :line_items

  def initialize(id, options)
    @id = id
    @row = options[0].to_i
    @column = options[1].to_i
  end

  def line_items=(value)
    @line_items = value.sort
  end
end
