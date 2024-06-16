# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

Product.destroy_all
Promo.destroy_all
PromoActivation.destroy_all
PromoReward.destroy_all
User.destroy_all

# Seed Products
products = [
  { sku: 'PROD001', description: 'High-quality leather wallet', name: 'Leather Wallet', factory_price: 2500 },
  { sku: 'PROD002', description: 'Stainless steel water bottle', name: 'Water Bottle', factory_price: 1200 },
  { sku: 'PROD003', description: 'Bluetooth wireless earbuds', name: 'Wireless Earbuds', factory_price: 7500 },
  { sku: 'PROD004', description: 'Portable solar charger', name: 'Solar Charger', factory_price: 5000 },
  { sku: 'PROD005', description: 'Ergonomic office chair', name: 'Office Chair', factory_price: 18000 }
]

products.each do |product|
  Product.find_or_create_by!(sku: product[:sku]) do |p|
    p.description = product[:description]
    p.name = product[:name]
    p.factory_price = product[:factory_price]
  end
end

# Seed Promos
promos = [
  { product_id: Product.find_by(sku: 'PROD001')&.id, description: '20% off on leather wallets', promo_type: :percentage },
  { product_id: Product.find_by(sku: 'PROD002')&.id, description: 'Buy one get one free on water bottles', promo_type: :bonus },
  { product_id: Product.find_by(sku: 'PROD003')&.id, description: '15$ discount', promo_type: :money },
  { product_id: Product.find_by(sku: 'PROD004')&.id, description: '10% off on solar chargers', promo_type: :percentage },
  { product_id: Product.find_by(sku: 'PROD005')&.id, description: '15% off on office chairs', promo_type: :percentage }
]

promos.each do |promo|
  Promo.find_or_create_by!(description: promo[:description]) do |p|
    p.product_id = promo[:product_id]
    p.promo_type = promo[:promo_type]
  end
end

# Seed Promo Activations
promo_activations = [
  { promo_id: Promo.first&.id, min_quantity: nil, min_value: 2000 },
  { promo_id: Promo.second&.id, min_quantity: 1, min_value: nil },
  { promo_id: Promo.third&.id, min_quantity: nil, min_value: 5000 },
  { promo_id: Promo.fourth&.id, min_quantity: nil, min_value: 4000 },
  { promo_id: Promo.fifth&.id, min_quantity: nil, min_value: 3000 }
]

promo_activations.each do |promo_activation|
  PromoActivation.find_or_create_by!(promo_id: promo_activation[:promo_id]) do |pa|
    pa.min_quantity = promo_activation[:min_quantity]
    pa.min_value = promo_activation[:min_value]
  end
end

# Seed Promo Rewards
promo_rewards = [
  { reward_id: Product.find_by(sku: 'PROD001')&.id, promo_id: Promo.first&.id, value: 1000, quantity: nil },
  { reward_id: Product.find_by(sku: 'PROD002')&.id, promo_id: Promo.second&.id, value: nil, quantity: 1 },
  { reward_id: Product.find_by(sku: 'PROD003')&.id, promo_id: Promo.third&.id, value: 750, quantity: nil },
  { reward_id: Product.find_by(sku: 'PROD004')&.id, promo_id: Promo.fourth&.id, value: 200, quantity: nil },
  { reward_id: Product.find_by(sku: 'PROD005')&.id, promo_id: Promo.fifth&.id, value: 1500, quantity: nil }
]

promo_rewards.each do |promo_reward|
  PromoReward.find_or_create_by!(promo_id: promo_reward[:promo_id], reward_id: promo_reward[:reward_id]) do |pr|
    pr.value = promo_reward[:value]
    pr.quantity = promo_reward[:quantity]
  end
end

# Seed Users
users = [
  { phone_number: "+520000000001", password: "password123" },
  { phone_number: "+520000000002", password: "password123" },
  { phone_number: "+520000000003", password: "password123" },
  { phone_number: "+520000000004", password: "password123" },
  { phone_number: "+520000000005", password: "password123" },
]

users.each do |user|
  User.find_or_create_by!(phone_number: user[:phone_number]) do |u|
    u.password = user[:password]
  end
end

puts "Seeded #{Product.count} products, #{Promo.count} promos, #{PromoActivation.count} promo activations, #{PromoReward.count} promo rewards, and #{User.count} users"