class PointCalculator
  def self.with_names(names)
    new(names)
  end

  def initialize(names)
    @names = names
  end

  def sum
    total = 0
    names.each do |name|
      if m = name.match(/^\s*(\d+)\s*-/)
        total += m[1].to_i
      end
    end
    total
  end

  protected

  attr_accessor :names
end