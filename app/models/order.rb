class Order < ApplicationRecord
  enum status: { pending: 1, done: 2 }
  enum side: { buy: 1, sell: 2 }
end