Deface::Override.new(:virtual_path  => "spree/admin/products/_form",
                     :insert_bottom => "[data-hook='admin_product_form_right']",
                     :name          => "products_promotion_exclude",
                     :text          => "<div class='field'>
                                          <%= f.check_box :promotion_exclude, :style => 'width:auto;' %>
                                          <%= f.label :promotion_exclude, Spree.t(:promotion_exclude) %>
                                        </div>")
