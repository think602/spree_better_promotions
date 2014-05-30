Spree::PermittedAttributes.product_attributes << :promotion_exclude

Rails.application.config.spree.promotions.rules << Spree::Promotion::Rules::ExcludeSpecials
