module Spire

  class Order < BasicData
    register_attributes :id, :order_no, :customer, :hold, :order_date, :address, :shipping_address, :customer_po, :fob, :terms_code, :terms_text, :freight, :taxes, :subtotal, :subtotal_ordered, :discount, :total_discount, :total, :total_ordered, :gross_profit, :items, :created_by, :modified_by, :created, :modified
  end

end