require 'spec_helper'

describe Product do
  let(:voucher) do
    Product.new("VOUCHER", 500)
  end

  let(:tschirt) do
    Product.new("TSHIRT", 2000)
  end

  let(:mug) do
    Product.new("MUG", 750)
  end


  describe "new product" do
    it "#name" do
      expect(voucher.name).to eq("VOUCHER")
      expect(tschirt.name).to eq("TSHIRT")
      expect(mug.name).to eq("MUG")
    end

    it "#price" do
      expect(voucher.price).to eq(500)
      expect(tschirt.price).to eq(2000)
      expect(mug.price).to eq(750)
    end
  end
end