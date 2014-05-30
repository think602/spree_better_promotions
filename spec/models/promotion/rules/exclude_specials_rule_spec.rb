require 'spec_helper'

describe Spree::Promotion::Rules::ExcludeSpecials do 
  let(:rule) { Spree::Promotion::Rules::ExcludeSpecials.new }
  let(:order) { mock_model(Spree::Order, user: nil, email: nil) }
  
  describe '#eligible?' do 
    it 'should be eligible for orders with 1 or more items' do 
      order.stub line_items: []
      rule.should_not be_eligible(order)
      
      order.stub line_items: [double(:line_item, amount: 30)]
      rule.should be_eligible(order)
    end
  end
  
  describe '#products' do 
    it 'should not contain promotion excluded products' do
      Spree::Product.should_receive(:where).with(promotion_exclude: false)
      rule.products
    end
  end
  
end
