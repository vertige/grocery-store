module Grocery

  require_relative 'order'

  class OnlineOrder < Order
    attr_reader :c_id, :status

    def initialize(id, products, customer_id, status)
      super(id, products)
      @c_id = customer_id
      @status = status
    end

    def total
      shipping = 10
      super + shipping

    end
  end #OnlineOrder
end #module