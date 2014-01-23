require_relative "../../lib/point_calculator"

describe PointCalculator do
  describe ".from_names" do
    let(:names) { ["2 - Archive Prospects, Not Delete", "3 - Email Invoices" ] }

    it "adds them up" do
      expect(PointCalculator.with_names(names).sum).to eq(5)
    end

    it "is forgiving on leading white space" do
      names << " 1 - Not much"
      expect(PointCalculator.with_names(names).sum).to eq(6)
    end

    it "is forgiving on trailing white space" do
      names << "2- Not much"
      expect(PointCalculator.with_names(names).sum).to eq(7)
    end

    it "does require at least a hyphen" do
      names << "3 super sloppy won't count"
      expect(PointCalculator.with_names(names).sum).to eq(5)
    end
  end
end
