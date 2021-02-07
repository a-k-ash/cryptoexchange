class OrderTransactionService
  def self.perform_transaction(order)
    transaction_order_type = order.buy? ? :sell : :buy
    inverted_orders = Order.send(transaction_order_type).pending.order('price asc, created_at asc')
    return if inverted_orders.blank?

    if order.buy?
      calculate_buy_volume(order, inverted_orders.where('price <= ?', order.price).first)
    elsif order.sell?
      calculate_sell_volume(order, inverted_orders.where('price >= ?', order.price).last)
    end
  end

  def self.calculate_buy_volume(buy_order, existing_order)
    return unless buy_order.price > existing_order.price

    Order.transaction do
      remaining_volume = existing_order.volume - buy_order.volume
      if remaining_volume > 0
        buy_order.update!(volume: remaining_volume, traded_volume: (buy_order.traded_volume + remaining_volume))
        existing_order.update(volume: remaining_volume, traded_volume: (existing_order.traded_volume + buy_order.volume))
      else
        buy_order.update(volume: 0, traded_volume: buy_order.volume, status: :done)
        existing_order.update(volume: 0, traded_volume: (existing_order.traded_volume + buy_order.volume), status: :done)
      end
    end
  end

  def self.calculate_sell_volume(sell_order, existing_order)
    return if existing_order.price > sell_order.price

    Order.transaction do
      traded_volume = sell_order.volume - existing_order.volume
      if traded_volume > 0
        sell_order.update!(volume: (sell_order.volume - traded_volume), traded_volume: (sell_order.traded_volume + traded_volume))
        existing_order.update(volume: (existing_order.volume - traded_volume), traded_volume: (existing_order.traded_volume + traded_volume))
      else
        sell_order.update(volume: 0, traded_volume: sell_order.volume, status: :done)
        existing_order.update(volume: 0, traded_volume: (existing_order.traded_volume + sell_order.volume), status: :done)
      end
    end
  end
end