class Discount

  def self.all
    ObjectSpace.each_object(self).to_a
  end

  def self.find_name(name)
    Discount.all.detect{|d| d.name == name}
  end

  def initialize(item:, minimum:, discount:, name:, item2: nil)
    @name = name
    @minimum = minimum
    @item = item
  end

  def name
    @name
  end

  def minimum
    @minimum
  end

  def item
    @item
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

  private

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
