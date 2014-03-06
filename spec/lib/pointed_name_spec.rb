require_relative "../../lib/pointed_name"

describe PointedName do
  describe "#with_points" do
    it "parses and creates a new name" do
      expect(PointedName.new("Sprint (0)").with_points(5.5)).to eq("Sprint (5.5)")
    end

    it "rounds out floats" do
      expect(PointedName.new("Sprint (1.0)").with_points(5.0)).to eq("Sprint (5)")
    end


    it "does nothing if there aren't parens" do
      expect(PointedName.new("Sprint").with_points(5)).to eq("Sprint")
    end
  end
end
