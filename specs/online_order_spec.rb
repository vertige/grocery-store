require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'

# TODO: uncomment the next line once you start wave 3
require_relative '../lib/online_order'
# You may also need to require other classes here

# Because an OnlineOrder is a kind of Order, and we've
# already tested a bunch of functionality on Order,
# we effectively get all that testing for free! Here we'll
# only test things that are different.

describe "OnlineOrder" do
  describe "#initialize" do
    before do
      #test data
      id = 1500
      products = {"Spumoni" => 9.87}
      customer_id = 3333
      status = "completed"
      @test_order = Grocery::OnlineOrder.new(id, products, customer_id, status)
    end
    it "Is a kind of Order" do
      @test_order.must_be_kind_of Grocery::Order
    end

    it "Can access Customer object" do
      @test_order.c_id.must_equal 3333
    end

    it "Can access the online order status" do
      @test_order.status.must_equal "completed"
    end
  end

  describe "#total" do
    before do
      #test data
      id = 1500
      products = {"Spumoni" => 9.87}
      customer_id = 3333
      status = "completed"
      @test_order = Grocery::OnlineOrder.new(id, products, customer_id, status)
    end

    it "Adds a shipping fee" do
      @test_order.total.must_equal (10.61 + 10)
    end

    it "Doesn't add a shipping fee if there are no products" do
      id = 1500
      products = {}
      customer_id = 3333
      status = "completed"
      test2 = Grocery::OnlineOrder.new(id, products, customer_id, status)
      test2.total.must_equal 0
    end
  end

  describe "#add_product" do
    before do
      #test data
      @id = 1500
      products = {"Spumoni" => 9.87}
      @customer_id = 3333
      status = "completed"
      @test_order = Grocery::OnlineOrder.new(@id, products, @customer_id, status)
    end

    it "Does not permit action for processing, shipped or completed statuses" do
      @test_order.add_product("Tofu", 30).must_equal false

      test3 = Grocery::OnlineOrder.new(@id, {"Spumoni" => 9.87}, @customer_id, "processing")
      test3.add_product("Tofu", 30).must_equal false

      test4 = Grocery::OnlineOrder.new(@id, {"Spumoni" => 9.87}, @customer_id, "shipped")
      test4.add_product("Tofu", 30).must_equal false
    end

    it "Permits action for pending and paid satuses" do
      test5 = Grocery::OnlineOrder.new(@id, {"Spumoni" => 9.87}, @customer_id, "pending")
      test5.add_product("Tofu", 30).must_equal true

      test6 = Grocery::OnlineOrder.new(@id, {"Spumoni" => 9.87}, @customer_id, "paid")
      test6.add_product("Tofu", 30).must_equal true
    end
  end

  describe "OnlineOrder.all" do
    before do
      @csv_data = CSV.read('support/online_orders.csv')
    end

    it "Returns an array of all online orders" do
      Grocery::OnlineOrder.all.must_be_kind_of Array

      5.times do
        Grocery::OnlineOrder.all[rand(0..(Grocery::OnlineOrder.all.length - 1))].must_be_kind_of Grocery::OnlineOrder
      end

      Grocery::OnlineOrder.all.length.must_equal @csv_data.length
    end

    it "Returns Customer and Status as from csv" do
      #Testing for first CSV order
      Grocery::OnlineOrder.all[0].c_id.must_equal @csv_data[0][2]

      Grocery::OnlineOrder.all[0].status.must_equal @csv_data[0][3]

      #Testing for last CSV order
      Grocery::OnlineOrder.all[-1].c_id.must_equal @csv_data[-1][2]

      Grocery::OnlineOrder.all[-1].status.must_equal @csv_data[-1][3]

    end
  end

  describe "OnlineOrder.find_by_customer" do
    before do
      Grocery::OnlineOrder.all
    end
    it "Returns an array of online orders for a specific customer ID" do
      Grocery::OnlineOrder.find_by_customer(25)[0].must_be_kind_of Grocery::OnlineOrder

      Grocery::OnlineOrder.find_by_customer(25).length.must_equal 6

      Grocery::OnlineOrder.find_by_customer(25)[0].id.must_equal 1.to_s
    end
  end
end
