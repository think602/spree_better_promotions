Spree::Product.class_eval do 
  
  def brand_id
    Spree::Taxonomy.select(:id).find_by_name('Brand').id
  end
  
  def brand
    taxons.find{ |t| t.taxonomy_id == brand_id }
  end
  
  def brand_name
    brand.nil? ? "" : brand.name
  end
  
end
