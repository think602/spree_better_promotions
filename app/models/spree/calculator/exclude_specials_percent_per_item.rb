module Spree
  class Calculator::ExcludeSpecialsPercentPerItem < Spree::Calculator
    preference :percent, :decimal, default: 0

    def self.description
      Spree.t(:percent_per_item_minus_excluded)
    end

    def compute(object=nil)
      return 0 if object.nil?
      object.line_items.reduce(0) do |sum, line_item|
        sum += value_for_line_item(line_item)
      end
    end

  private
    def matching_products
      if compute_on_promotion?
        self.calculable.promotion.rules.map do |rule|
          rule.respond_to?(:products) ? rule.products : []
        end.flatten
      end
    end

    def value_for_line_item(line_item)
      if compute_on_promotion?
        return 0 unless matching_products.blank? or include_item?(line_item)
      end
      ((line_item.price * line_item.quantity) * preferred_percent) / 100
    end

    # Determines wether or not the calculable object is a promotion
    def compute_on_promotion?
      @compute_on_promotion ||= self.calculable.respond_to?(:promotion)
    end
    
    def include_item?(line_item)
      matching_products.include?(line_item.product)
    end
  end
end