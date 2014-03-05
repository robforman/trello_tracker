class PointCalculator
  def self.with_names(names)
    new(names)
  end

  def initialize(names)
    @names = names
  end

  def sum
    total = 0.0
    names.each do |name|
      if m = name.match(/^\s*([0-9]{1,2}(?:\.[0-9]{1,2})?)\s*-/)
        total += m[1].to_f
      end
    end
    total
  end

  protected

  attr_accessor :names
end