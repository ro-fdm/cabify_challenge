require 'spec_helper'

describe Checkout do
  let(:checkout) do
    Checkout.new
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


end