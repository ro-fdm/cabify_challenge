require 'spec_helper'

describe Checkout do

  before(:each) do
    Product.new("VOUCHER", 500)
    Product.new("TSHIRT", 2000)
    Product.new("MUG", 750)
  end

  let(:checkout) do
    Checkout.new
  end

  let(:twoxone) do
    pricing_rules = {
      twoxone:["VOUCHER"]
    }
  end

  let(:bulk) do
    pricing_rules = {
      bulk: { "TSHIRT"=> 100 },
    }
  end

  let(:both) do
    pricing_rules = {
      twoxone:["VOUCHER"],
      bulk: { "TSHIRT"=> 100 }
    }
  end

  let(:combined_products) do
    pricing_rules = {
      combined_products: [{item1: "TSHIRT", item2: "MUG", discount: 750}]
    }
  end

  describe "with single product" do
    it "voucher product" do
      co = checkout
      co.scan("VOUCHER")
      
      expect(co.total).to eq("5.00 €")
    end

    it "tschirt product" do
      co = checkout
      co.scan("TSHIRT")
      
      expect(co.total).to eq("20.00 €")
    end

    it "mug product" do
      co = checkout
      co.scan("MUG")
      
      expect(co.total).to eq("7.50 €")
    end

    # it "product not exist" do
    #   co = checkout
    #   co.scan("no existe")

    #   expect(co.price).to eq("error")
    # end
  end

  describe "with more products" do
    it "sum prices" do
      co = checkout
      co.scan("VOUCHER")
      co.scan("TSHIRT")
      
      expect(co.total).to eq("25.00 €")
    end

    it "sum prices third products" do
      co = checkout
      co.scan("VOUCHER")
      co.scan("TSHIRT")
      co.scan("MUG")
      
      expect(co.total).to eq("32.50 €")
    end
  end

  describe "with pricing rules" do
    it "with discount 2*1" do
      co = Checkout.new(pricing_rules: twoxone)
      co.scan("VOUCHER")
      co.scan("TSHIRT")
      co.scan("VOUCHER")

      expect(co.total).to eq("25.00 €")
    end

    it "whitout discount for bulk" do
      co = Checkout.new(pricing_rules: bulk)
      co.scan("TSHIRT")
      co.scan("VOUCHER")
      co.scan("TSHIRT")

      expect(co.total).to eq("45.00 €")
    end

    it "whit discount for bulk" do
      co = Checkout.new(pricing_rules: bulk)
      co.scan("TSHIRT")
      co.scan("TSHIRT")
      co.scan("TSHIRT")
      co.scan("VOUCHER")
      co.scan("TSHIRT")

      expect(co.total).to eq("81.00 €")
    end

    it "whit both discount (2*1 and bulk)" do
      co = Checkout.new(pricing_rules: both)
      co.scan("VOUCHER")
      co.scan("TSHIRT")
      co.scan("VOUCHER")
      co.scan("VOUCHER")
      co.scan("MUG")
      co.scan("TSHIRT")
      co.scan("TSHIRT")

      expect(co.total).to eq("74.50 €")
    end

    it "mug free with tschirt" do
      co = Checkout.new(pricing_rules: combined_products)
      co.scan("TSHIRT")
      co.scan("MUG")

      expect(co.total).to eq("20.00 €")
    end

  end
end