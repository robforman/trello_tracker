class PointedName
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def with_points(v)
    name.gsub(/\(\d+\)/, "(#{v})")
  end
end