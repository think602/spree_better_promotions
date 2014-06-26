Spree::PermittedAttributes.product_attributes << :promotion_exclude

Rails.application.config.spree.promotions.rules << Spree::Promotion::Rules::ExcludeSpecials

# Rails.application.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::ExcludeSpecialsPercentPerItem
