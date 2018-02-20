require "awesome_print"
class Checkout

  PRODUCTS = {
    VOUCHER: { name: "VOUCHER", price: 500},
    TSHIRT: { name: "TSHIRT", price: 2000},
    MUG: { name: "MUG", price: 750}
  }

  def initialize(pricing_rules:{})
    @pricing_rules = pricing_rules
    @cart = []
  end

  def scan(name_item)
    @cart << name_item
  end

  def total
    total = 0
    discounts = 0
    @cart.each do |item|
      total += price(item)
    end
    discounts = apply_discounts unless @pricing_rules.empty?
    total = total - discounts
    price_output(total)
  end

  private

  def price(item)
    # prices always in integers
    if PRODUCTS.keys.include?(item.to_sym)
      PRODUCTS[item.to_sym][:price]
    else
      "product not exist"
    end
  end

  def price_output(price)
    sprintf("%.2f", (price/100.0)) + " €"
  end

  def apply_discounts
    discounts = 0
    discounts += apply_twoxone if @pricing_rules[:twoxone]
    discounts += apply_bulk if @pricing_rules[:bulk]
    discounts
  end

  def apply_twoxone
    discounts = 0
    @pricing_rules[:twoxone].each do |item_name|
      if @cart.include?(item_name)
        number_discounts = @cart.select{|item| item == item_name}.count / 2
        discounts = number_discounts * price(item_name)
      end
    end
    discounts
  end

  def apply_bulk
    discounts = 0
    @pricing_rules[:bulk].each do |item_name|
      if @cart.include?(item_name)
        number_discounts = @cart.select{|item| item == item_name}.count
        discounts = number_discounts * 100
      end
    end
    discounts
  end
end

# convertir el 100 de bulk en algo que no sea un numero magico