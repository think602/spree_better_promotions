class AddPromotionExcludeToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :promotion_exclude, :boolean
  end
end
