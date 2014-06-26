module Spree
  class Calculator::ExcludeSpecialsPercentPerItem < Spree::Calculator
    preference :percent, :decimal, default: 0

    def self.description
      Spree.t(:percent_per_item_minus_excluded)
    end

    def compute(object=nil)
      return 0 if object.nil?
      
      ex_brands = excluded_brands(object)
      
      object.line_items.reduce(0) do |sum, line_item|
        if ex_brands.include?(line_item.product.brand)
          sum += 0
        else
          sum += discount(line_item)
        end
      end
    end

  private
    
    # no doc
    def order_brands(object)
      object.line_items.collect{|li| li.product.brand}.flatten
    end
    
    # no doc
    def invalid_brand_name_sets
      [ 
        ['Loaded', 'Orangatang']
      ]
    end
    
    # no doc
    def brand_taxonomy_id
      Spree::Taxonomy.select(:id).find_by_name('Brand').id
    end
    
    # Returns array of Spree::Taxon objects.
    def invalid_brand_set(brand_name_set)
      brand_name_set.collect do |brand_name|
        Spree::Taxon.where(name: brand_name, taxonomy_id: brand_taxonomy_id).limit(1).first
      end.flatten
    end
    
    # Returns double nested array of Spree::Taxon objects that when present in
    # a Spree::Order disqualify each line item from that Spree::Taxon brand.
    # 
    # For example,
    # 
    # [
    #   [#<Spree::Taxon name: 'Loaded'>, #<Spree::Taxon name: 'Orangatang'>]
    # ]
    # 
    def invalid_brand_sets
      invalid_brand_name_sets.collect do |brand_name_set|
        invalid_brand_set(brand_name_set)
      end
    end
  
    # Returns array of Spree::Taxon brands excluded from discounts.
    def excluded_brands(object)
      obs = order_brands(object)
      invalid_brand_sets.collect{|ibs| ibs if (ibs & obs).count == ibs.count}.flatten.compact
    end
    
    # no doc
    def discont(line_item)
      ((line_item.price * line_item.quantity) * preferred_percent) / 100
    end
        
  end
end
