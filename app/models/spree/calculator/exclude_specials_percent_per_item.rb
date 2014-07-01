module Spree
  class Calculator::ExcludeSpecialsPercentPerItem < Spree::Calculator
    preference :percent, :decimal, default: 0

    def self.description
      Spree.t(:percent_per_item_minus_excluded)
    end

    def compute(object=nil)
      return 0 if object.nil?
      
      object.line_items.reduce(0) do |sum, line_item|
        sum += discount(line_item)
      end
    end

  private
    
    # no doc
    def compute_discount(line_item)
      if line_item.product.promotion_exclude == true
        return 0
      else
        return ((line_item.price * line_item.quantity) * preferred_percent) / 100
      end
    end
        
  end
end
