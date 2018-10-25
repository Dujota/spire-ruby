module Spire

  class Order < BasicData
    register_attributes :id, :order_no, :customer, :status, :type, :hold,
      :order_date, :address, :shipping_address, :customer_po, :fob, :terms_code,
      :terms_text, :freight, :taxes, :subtotal, :subtotal_ordered, :discount,
      :total_discount, :total, :total_ordered, :gross_profit, :items, :created_by,
      :modified_by, :created, :modified,
      readonly: [
        :created_by, :modified_by, :created, :modified,
      ]

    validates_acceptance_of :id, :customer, :address, :shipping_address, :items

    ACTIVE = 0
    ON_HOLD = 1
    INACTIVE = 2

    SYMBOL_TO_STRING = {
      id: 'id',
      order_no: 'orderNo',
      customer: 'customer',
      status: 'status',
      type: 'type',
      hold: 'hold',
      order_date: 'orderDate',
      address: 'address',
      shipping_address: 'shippingAddress',
      customer_po: 'shippingPO',
      fob: 'fob',
      terms_code: "termsCode",
      terms_text: 'termsText',
      freight: 'freight',
      taxes: 'taxes',
      subtotal: 'subtotal',
      subtotal_ordered: 'subtotalOrdered',
      discount: 'discount',
      total_discount: 'totalDiscount',
      total: 'total',
      total_ordered: 'totalOrdered',
      gross_profit: 'grossProfit',
      items: 'items',
      created_by: 'createdBy',
      modified_by: 'modifiedBy',
      created: 'created',
      modified: 'modified'
    }

    class << self
       # Find a specific order by its id.
      #
      # @raise [Spire::Error] if the order could not be found.
      #
      # @return [Spire::Order]

      def find(id, params = {})
        client.find('/sales/orders', id, params)
      end

      # Search for order by query. This will even return inactive orders!
      #
      # @raise [Spire::Error] if the order could not be found.
      #
      # @return [Spire::Order]

      def search(query)
        client.find_many(Spire::Order, '/sales/orders', {q: query})
      end

      # Create a new item and save it on Spire.
      #
      # @param [Hash] options
      # @option options [Hash] :customer the spire customer who will be associated with the order
      # @option options [Hash] :address this is the billing address for the customer
      # @option options [Hash] :shippingAddress this is the shipping address that the order will be sent to (defaults to the billing address if none provided)
      # @option options [Array] :items this is an array of hashes that will accept an inventory item that will have a hash


    end
  end

end