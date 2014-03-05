class PointedName
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def with_points(v)
    name.gsub(/\(([0-9]{1,2}(?:\.[0-9]{1,2})?)\)/, "(#{trim(v)})")
  end

  private 
  
  def trim(num)
    i, f = num.to_i, num.to_f
    i == f ? i : f
  end
end