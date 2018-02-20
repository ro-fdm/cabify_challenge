require "awesome_print"
require "product.rb"
class Checkout
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
    Product.find_name(item).price
    #TODO ERROR CONTROL
  end

  def price_output(price)
    sprintf("%.2f", (price/100.0)) + " €"
  end

  def apply_discounts
    discounts = 0
    discounts += apply_twoxone if @pricing_rules[:twoxone]
    discounts += apply_bulk if @pricing_rules[:bulk]
    discounts += apply_combined if @pricing_rules[:combined_products]
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
  SOLO SI HAY MAS DE TRES
    @pricing_rules[:bulk].each do |item_name, bulk_discount|
      if @cart.include?(item_name)
        number_discounts = @cart.select{|item| item == item_name}.count
        if number_discounts >= 3
          discounts = number_discounts * bulk_discount
        end
      end
    end
    discounts
  end

  def apply_combined
    discounts = 0
    @pricing_rules[:combined_products].each do |rule|
      if ( @cart & [ rule[:item1], rule[:item2] ] ).any?
        number_item2 = @cart.select{|item| item == rule[:item2]}.count
        number_item1  = @cart.select{|item| item == rule[:item1]}.count
        if number_item2 <= number_item1
          number_discounts = number_item2
        else
          number_discounts = number_item_1
        end
        discounts = number_discounts * rule[:discount]
      end
    end
    discounts
  end
end