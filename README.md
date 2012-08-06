Spree Sale Products
=======

Provides a per variant reduced price option. Logic works similiar to [spree_volume_pricing](https://github.com/spree/spree_volume_pricing).

This could be done through promotions. However, for my specific use case, using promotions to discount an item (or a bunch of different items)
would result in a **very large** number of promotions promotional actions, rules, etc in the DB and would clutter up the promotion system in general.

What is provided here is a very lightweight 'sale price' functionality, easily allowing you to set the sale price for items through the product / variant admin.

This extension is compatible with spree_volume_pricing, the best price is chosen when both extensions are loaded.

Installation
------------
  
    bundle exec rails g spree_sale_products:install

Authors
-------
* @sebastyuiop
* @iloveitaly

Copyright (c) 2011 sebastyuiop, released under the New BSD License