require 'spec_helper'

describe Spree::Calculator::ExcludeSpecialsPercentPerItem do 
  let!(:product1) { double("Product") }
  let!(:product2) { double("Product") }
  
  let!(:line_item1) { double("LineItem", :quantity => 5, :product => product1, :price => 10) }
  let!(:line_item2) { double("LineItem", :quantity => 1, :product => product2, :price => 10) }
  let!(:line_items) {[line_item1, line_item2]}
  
  let!(:object) { double("Order", :line_items => line_items) }

  let!(:promotion_calculable) { double("Calculable", :promotion => promotion) }

  let!(:promotion) { double("Promotion", :rules => [double("Rule", :products => [product1])]) }
  let!(:promotion_without_rules) { double("Promotion", :rules => []) }
  let!(:promotion_without_products) { double("Promotion", :rules => [double("Rule", :products => [])]) }

  let!(:calculator) { Spree::Calculator::ExcludeSpecialsPercentPerItem.new(:preferred_percent => 25) }

  it "has a translation for description" do
    expect(calculator.description).to_not include("translation missing")
    expect(calculator.description).to eq Spree.t(:percent_per_item_minus_excluded)
  end

  it "correctly calculates per item promotion" do
    calculator.stub(:calculable => promotion_calculable)
    expect(calculator.compute(object).to_f).to eq 12.5
  end

  it "correctly calculates per item promotion without rules" do
    calculator.stub(:calculable => double("Calculable", :promotion => promotion_without_rules))
    expect(calculator.compute(object).to_f).to eq 15.0
  end

  it "correctly calculates per item promotion without products" do
    calculator.stub(:calculable => double("Calculable", :promotion => promotion_without_products))
    expect(calculator.compute(object).to_f).to eq 15.0
  end

  it "returns 0 when no object passed" do
    calculator.stub(:calculable => promotion_calculable)
    expect(calculator.compute).to eq 0
  end

  it "computes on promotion when promotion is present" do
    expect(calculator.send(:compute_on_promotion?)).to_not be_true
    calculator.stub(:calculable => promotion_calculable)
    expect(calculator.send(:compute_on_promotion?)).to be_true
  end

  # test that we do not fail when one promorule does not respond to products
  context "does not fail if a promotion rule does not respond to products" do
    before { promotion.stub :rules => [double("Rule", :products => [product1]), double("Rule")] }
    specify do
      calculator.stub(:calculable => promotion_calculable)
      expect { calculator.send(:matching_products) }.not_to raise_error
    end
  end
end
