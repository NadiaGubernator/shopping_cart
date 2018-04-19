class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  def total_price
    product.price * quantity
  end

  def removing_item
    (quantity > 1) ? update_attributes(quantity: quantity - 1) : destroy
  end
end
