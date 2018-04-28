class LineItem < ApplicationRecord  
  belongs_to :cart
  belongs_to :order,   optional: true
  belongs_to :product, optional: true

  def total_price
    product.price * quantity
  end

  # def removing_item
  #   (quantity > 1) ? update_attributes(quantity: quantity - 1) : destroy
  # end

  def decrement_or_destroy!
    quantity > 1 ? decrement!(:quantity) : destroy!
  end
end
