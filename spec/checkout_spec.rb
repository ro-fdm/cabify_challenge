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

  let(:one_free) do
    pricing_rules = {
      one_free: [{ item:"VOUCHER", minimum: 2}]
    }
  end

  let(:bulk) do
    pricing_rules = {
      bulk: [{ item: "TSHIRT", discount: 100, minimum: 3 }],
    }
  end

  let(:both) do
    pricing_rules = {
      one_free: [{ item: "VOUCHER", minimum: 2}],
      bulk: [{ item: "TSHIRT", discount: 100, minimum: 3}]
    }
  end

  let(:combined_products) do
    pricing_rules = {
      combined_products: [{item: "TSHIRT", item2: "MUG", discount: 750, minimum: 1}]
    }
  end

  let(:both_combined) do
    pricing_rules = {
      combined_products: [{item: "TSHIRT", item2: "MUG", discount: 750, minimum: 1}],
      bulk: [{ item: "TSHIRT", discount: 100, minimum: 3}]
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

    it "product not exist" do
      co = checkout
      co.scan("no existe")
      co.total
      expect(co.total).to eq("error")
    end
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

    describe "with discount one free" do
      it "with discount 2*1" do
        co = Checkout.new(pricing_rules: one_free)
        co.scan("VOUCHER")
        co.scan("TSHIRT")
        co.scan("VOUCHER")

        expect(co.total).to eq("25.00 €")
      end

      it "with discount no apply" do
        co = Checkout.new(pricing_rules: one_free)
        co.scan("VOUCHER")
        co.scan("TSHIRT")

        expect(co.total).to eq("25.00 €")
      end

      it "with discount 3*2" do
        pricing_rules = {
          one_free: [{ item:"VOUCHER", minimum: 3}]
        }
        co = Checkout.new(pricing_rules: pricing_rules)
        co.scan("VOUCHER")
        co.scan("TSHIRT")
        co.scan("VOUCHER")
        co.scan("VOUCHER")

        expect(co.total).to eq("30.00 €")
      end


      it "with discount 4*3" do
        pricing_rules = {
          one_free: [{ item:"VOUCHER", minimum: 4}]
        }
        co = Checkout.new(pricing_rules: pricing_rules)
        co.scan("VOUCHER")
        co.scan("TSHIRT")
        co.scan("VOUCHER")
        co.scan("VOUCHER")
        co.scan("VOUCHER")

        expect(co.total).to eq("35.00 €")
      end
    end

    describe "with bulk discount" do
      it "whitout enought products" do
        co = Checkout.new(pricing_rules: bulk)
        co.scan("TSHIRT")
        co.scan("VOUCHER")
        co.scan("TSHIRT")

        expect(co.total).to eq("45.00 €")
      end

      it "whit enought products" do
        co = Checkout.new(pricing_rules: bulk)
        co.scan("TSHIRT")
        co.scan("TSHIRT")
        co.scan("TSHIRT")
        co.scan("VOUCHER")
        co.scan("TSHIRT")

        expect(co.total).to eq("81.00 €")
      end

    end

    describe "with two discount" do
      it "whit (2*1 and bulk)" do
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

      it "with bulk and combined products" do
        co = Checkout.new(pricing_rules: both_combined)
        co.scan("VOUCHER")
        co.scan("TSHIRT")
        co.scan("VOUCHER")
        co.scan("VOUCHER")
        co.scan("MUG")
        co.scan("TSHIRT")
        co.scan("TSHIRT")

        expect(co.total).to eq("72.00 €")
      end
    end

    describe "with combined_products" do

      it "mug free with tschirt" do
        co = Checkout.new(pricing_rules: combined_products)
        co.scan("TSHIRT")
        co.scan("MUG")

        expect(co.total).to eq("20.00 €")
      end

      it "mug not include" do
        co = Checkout.new(pricing_rules: combined_products)
        co.scan("TSHIRT")

        expect(co.total).to eq("20.00 €")
      end
    end
  end
end