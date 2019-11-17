require 'pry'

def consolidate_cart(cart)
  new_hash = {}
  cart.each do |element_hash|
    element_name = element_hash.keys[0]
  
  if new_hash.has_key?(element_name)
    new_hash[element_name][:count] += 1
    else
    new_hash[element_name] = {
      count: 1,
      price: element_hash[element_name][:price],
      clearance: element_hash[element_name][:clearance]
    }
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon[:item]
    coupon_item = "#{item} W/COUPON"
    if cart[item] 
      if cart[item][:count] >= coupon[:num]  
        if !cart.has_key?(coupon_item)
      cart[coupon_item] = {price: coupon[:cost] / coupon[:num], clearance: cart[item][:clearance], count: coupon[:num]}
    else 
    cart[coupon_item][:count] += coupon[:num]
    end
      cart[item][:count] -= coupon[:num]
    end
  end
end
  cart
end

def apply_clearance(cart)
  cart.each do |item, stats|
    if stats[:clearance]
      stats[:price] -= (stats[:price] * 0.2).round(2)
  end
  end
  cart
end

def checkout(cart, coupons)
  sorted_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(sorted_cart, coupons)
  applied_discount = apply_clearance(applied_coupons)
  total = applied_discount.reduce(0) { |acc, (key, value)| acc += value[:price] * value[:count] }
  total > 100 ? total * 0.9 : total
end
