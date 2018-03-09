require 'spec_helper'

describe Discount do
  before(:each) do
    @one_free = Discount.new(item:"VOUCHER", discount:500, minimum:1, name: "one_free")
    @bulk = Discount.new(item: "TSHIRT", discount: 100, minimum: 3, name: "bulk")
    @combined_products = Discount.new(item: "TSHIRT", item2: "MUG", discount: 750, minimum: 1, name: "combined_products")
  end

  describe "new discount" do
    it "#name" do
      expect(@one_free.name).to eq("one_free")
      expect(@bulk.name).to eq("bulk")
      expect(@combined_products.name).to eq("combined_products")
    end

    it "#minimum" do
      expect(@one_free.minimum).to eq(1)
      expect(@bulk.minimum).to eq(3)
    end

    it "#item" do
      expect(@one_free.item).to eq("VOUCHER")
      expect(@bulk.item).to eq("TSHIRT")
      expect(@combined_products.item).to eq("TSHIRT")
    end
  end

  describe "list all products" do
    it "#all" do
      expect(Discount.all.count).not_to eq(0)
    end

    it "find_name" do
      expect(Discount.find_name("one_free")).not_to be_nil
      expect(Discount.find_name("rocio")).to be_nil
    end

  end
end