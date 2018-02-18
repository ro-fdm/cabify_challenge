require "awesome_print"
class Checkout

  def initialize(pricing_rules: {})
    #@pricing_rules = pricing_rules
    @cart = []
  end

  def scan(name_item)
    @cart << name_item
  end

  def total
    total = 0
    @cart.each do |item|
      total += price(item)
    end
    price_output(total)
  end

  def price(item)
    if item == "VOUCHER"
      500 # guardar siempre los precios como enteros
    elsif item == "TSHIRT"
      2000
    elsif item == "MUG"
      750
    else
      "product not exist"
    end
  end

  def price_output(price)
    sprintf("%.2f", (price/100.0)) + " €"
  end
end

# co = Checkout.new
# co.scan("VOUCHER")
# ap co.total