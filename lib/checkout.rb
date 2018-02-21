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
    @pricing_rules.each do |method_name, rules|
      rules.each do |rule|
        discounts += general_rule(method_name, rule)
      end
    end
    discounts
  end

  def general_rule(method_name, rule)
    discounts = 0
    number_discounts = 0
    if (@cart.include?(rule[:item]) && @cart.select{|item| item == rule[:item]}.count >= rule[:minimum])
      number_discounts = send(method_name, rule)
    end
    discounts = number_discounts * rule[:discount]
  end

  def twoxone(rule)
    rule[:discount] = price(rule[:item])
    @cart.select{|item| item == rule[:item]}.count / rule[:minimum]
  end

  def bulk(rule)
    number_items = @cart.select{|item| item == rule[:item]}.count
    if number_items >= rule[:minimum]
      number_items
    else
      0
    end
  end

  def combined_products(rule)
    if @cart.include?(rule[:item2])
      number_item2 = @cart.select{|item| item == rule[:item2]}.count
      number_item1  = @cart.select{|item| item == rule[:item]}.count
      if number_item2 <= number_item1
        number_discounts = number_item2
      else
        number_discounts = number_item_1
      end
    end
    number_discounts
  end
end
