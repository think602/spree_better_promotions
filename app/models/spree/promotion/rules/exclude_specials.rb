module Spree
  class Promotion
    module Rules
    
      class ExcludeSpecials < Spree::PromotionRule
        def eligible?(order, options = {})
          order.line_items.count >= 1
        end

        def products
          Spree::Product.where(promotion_exclude: false)
        end
      end
      
    end 
  end
end
