module Spree
  class Promotion
    module Rules
    
      class ExcludeSpecials < Spree::PromotionRule
        def eligible?(order, options = {})
          order.line_items.count > 0
        end

        def products
          Spree::Product.where('promotion_exclude IS NOT TRUE')
        end
      end
      
    end 
  end
end
