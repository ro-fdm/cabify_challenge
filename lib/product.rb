class Product

  def self.all
     ObjectSpace.each_object(self).to_a
  end

  def self.find_name(name)
    Product.all.detect{|p| p.name == name}
  end

  def initialize(name, price)
    @name = name
    @price = price
  end

  def price
    @price
  end

  def name
    @name
  end
end