class Product

  def self.all
     ObjectSpace.each_object(self).to_a
  end

  def self.find_name(name)
    Product.all.detect{|p| p.name == name}
  end

  def initialize(product_name, price)
    @name = product_name
    @price = price
  end

  def price
    # prices always in integers 2.55 € => 255
    @price
  end

  def name
    @name
  end
end