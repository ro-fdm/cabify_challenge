require 'spec_helper'

describe Product do
  before(:each) do
    @voucher = Product.new("VOUCHER", 500)
    @tshirt = Product.new("TSHIRT", 2000)
    @mug = Product.new("MUG", 750)
  end


  describe "new product" do
    it "#name" do
      expect(@voucher.name).to eq("VOUCHER")
      expect(@tshirt.name).to eq("TSHIRT")
      expect(@mug.name).to eq("MUG")
    end

    it "#price" do
      expect(@voucher.price).to eq(500)
      expect(@tshirt.price).to eq(2000)
      expect(@mug.price).to eq(750)
    end
  end

  describe "list all products" do
    it "#all" do
      expect(Product.all.count).not_to eq(0)
    end

    it "find_name" do
      expect(Product.find_name("VOUCHER")).not_to be_nil
      expect(Product.find_name("rocio")).to be_nil
    end

  end
end