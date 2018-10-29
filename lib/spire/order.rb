module Spire

  class Order < BasicData
    register_attributes :id, :order_no, :customer, :status, :type, :hold,
      :order_date, :address, :shipping_address, :customer_po, :fob, :terms_code,
      :terms_text, :freight, :taxes, :subtotal, :subtotal_ordered, :discount,
      :total_discount, :total, :total_ordered, :gross_profit, :items, :created_by,
      :modified_by, :created, :modified, :background_color,
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
      modified: 'modified',
      background_color: 'backgroundColor'
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
        client.find_many(Spire::Order, '/sales/orders/', {q: query})
      end

      # Create a new item and save it on Spire.
      #
      # @param [Hash] options
      # @option options [Hash] :customer the spire customer who will be associated with the order
      # @option options [Hash] :address this is the billing address for the customer
      # @option options [Hash] :shipping_address this is the shipping address that the order will be sent to (defaults to the billing address if none provided)
      # @option options [Array] :items this is an array of hashes that will accept an inventory item that will have a hash example input from the web client: items: [ { "inventory": {"id": 123} } ]
      # this array can also accept a desctiption and comment object that will create a comment on the order itself ex: items: [{"description":"MAKE COMMENT THRU API","comment":"MAKE COMMENT THRU API"}]

      # @raise [Spire::Error] if the order could not be created.
      #
      # @return [Spire::Order]

      def create(options)
        client.create(
          :order,
          'customer' => options[:customer],
          'address' => options[:address],
          'shippingAddress' => options[:shipping_address],
          'items' => options[:items],
        )
      end
    end

    # Update the fields of an order.
    #
    # Supply a hash of string keyed data retrieved from the Spire API representing an order.
    #
    # Note that this this method does not save anything new to the Spire API,
    # it just assigns the input attributes to your local object. If you use
    # this method to assign attributes, call `save` or `update!` afterwards if
    # you want to persist your changes to Spire.
    #

    def update_fields(fields)
      # instead of going through each attribute on self, iterate through each item in field and update from there
      self.attributes.each do |k, v|
        attributes[k.to_sym] = fields[SYMBOL_TO_STRING[k.to_sym]] || fields[k.to_sym] || attributes[k.to_sym]
      end

      attributes[:id] = fields[SYMBOL_TO_STRING[:id]] || attributes[:id]
      self
    end

    # Saves a record.
    #
    # @raise [Spire::Error] if the order could not be saved
    #
    # @return [String] The JSON representation of the saved order returned by
    #     the Spire API.

    def save
      # If we have an id, just update our fields
      return update! if id

      options = {
        customer: customer || {},
        address: address || {},
        shippingAddress: shippingAddress || {},
        items: items || {},
        backgroundColor: background_color || 16777215
      }

      from_response client.post("/sales/orders/", options)
    end

    # Update an existing record.
    #
    # Warning: this updates all fields using values already in memory. If
    # an external resource has updated these fields, you should refresh wuth update fields mehtod!
    # this object before making your changes, and before updating the record.
    #
    # @raise [Spire::Error] if the order could not be updated.
    #
    # @return [String] The JSON representation of the updated order returned by
    # the Spire API.

    def update!
      @previously_changed = changes
      # extract only new values to build payload
      payload = Hash[changes.map { |key, values| [SYMBOL_TO_STRING[key.to_sym].to_sym, values[1]] }]
      @changed_attributes.clear

      client.put("/sales/orders/#{id}", payload)
    end

    # Delete this order
    #
    # @return [String] the JSON response from the Spire API
    def delete
      client.delete("/sales/orders/#{id}")
    end

    # Sets status to inactive.
    # This will not make any changes on Spire.
    # If you want to save changes to Spire call .save or .update!
    def make_inactive
      self.status = INACTIVE
    end

    # Sets status to on hold.
    # This will not make any changes on Spire.
    # If you want to save changes to Spire call .save or .update!
    def put_on_hold
      self.status = ON_HOLD
    end

    # Sets status to active.
    # This will not make any changes on Spire.
    # If you want to save changes to Spire call .save or .update!
    def make_active
      self.status = ACTIVE
    end

    # Is the record valid?
    def valid?
      !order_no.nil? && !items.nil? && !customer.nil?
    end
  end
end