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
    total = @cart.inject(0){|sum, item| sum + price(item) }
    discounts = @pricing_rules.empty? ? 0 : sum_discounts
    price_output(total - discounts)
  end

  private

  def price(item)
    product = Product.find_name(item)
    raise ProductNotFound unless product # esta es tu clase custom
    product.price
  end

  def price_output(price)
    sprintf("%.2f", (price/100.0)) + " €"
  end

  def sum_discounts
    @pricing_rules.inject(0) do |sum_discounts, (discount, rules)|
      sum_discounts + apply_discounts(discount, rules)
    end
  end

  def apply_discounts(discount, rules)
    rules.inject(0){|sum, rule| sum + general_policy(discount, rule) }
  end

  def general_condition(rule)
    (@cart.include?(rule[:item]) && @cart.select{|item| item == rule[:item]}.count >= rule[:minimum])
  end

  def general_policy(discount, rule)
    discounts = 0

    unless rule[:discount]
      rule[:discount] = price(rule[:item])
    end

    number_discounts = general_condition(rule) ? send(discount, rule) : 0

    discounts = number_discounts * rule[:discount]
  end

  def one_free(rule)
    @cart.select{|item| item == rule[:item]}.count / rule[:minimum]
  end

  def bulk(rule)
    number_items = @cart.select{|item| item == rule[:item]}.count
    number_items >= rule[:minimum] ? number_items : 0
  end

  def combined_products(rule)
    number_discounts = 0
    if @cart.include?(rule[:item2])
      number_item  = @cart.select{|item| item == rule[:item]}.count
      number_item2 = @cart.select{|item| item == rule[:item2]}.count

      number_discounts = (number_item2 <= number_item) ? number_item2 : number_item
    end
    number_discounts
  end
end
