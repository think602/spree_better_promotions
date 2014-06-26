module SpreeBetterPromotions
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_better_promotions'
    
    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end
    
    config.to_prepare &method(:activate).to_proc
    
    initializer 'spree_better_promotions.register.calculators', after: 'spree.register.calculators' do |app|
      app.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::ExcludeSpecialsPercentPerItem
      app.config.spree.promotions.rules << Spree::Promotion::Rules::ExcludeSpecials
      Spree::PermittedAttributes.product_attributes << :promotion_exclude
    end
    
  end
end
