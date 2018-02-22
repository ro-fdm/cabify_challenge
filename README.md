Code to cabify mobile challenge

Interfaz: 
To use is necessary to add Products. The Product have a name and a price
```
Product.new("VOUCHER", 500)
```

To checkout:
```
co = Checkout.new(pricing_rules)
co.scan("VOUCHER") # name of product
co.total # result price of cart```
```
pricing_rules: are the discounts. It is a Hash with the name of type of discount like key and like value a Array of Hashes, where each hash is a specific discount rule to apply.

The discounts have two arguments mandatory:
item/s: product is necesary buy to apply discount
minimum: minimum amount of items necesary to apply discount

Exist three types of descounts:
- one_free: Typical discount if you bougth two o three, you get one free
Example: 
```
  pricing_rules = {
      one_free: [{ item:"VOUCHER", minimum: 2}]
    }
```
- bulk: If you pay certain number, you price is less.
  In bulk you have a third mandatory argument( discount). Its the amount you rest to each item.
Example: 
```
  pricing_rules = {
      bulk: [{ item: "TSHIRT", discount: 100, minimum: 3 }],
    }
```

- combined_items: If you buy two object, the price is less.
  In this case you add a fourth mandatory argument (item2) that is a second neccesary object.

Example: 
```
  pricing_rules = {
      combined_products: [{item: "TSHIRT", item2: "MUG", discount: 750, minimum: 1}]
    }
```
