module V1
  class OrdersController < ActionController::API

    def create
      order = Order.create!(price: params[:price].to_f, volume: params[:volume].to_f, side: order_side)
      if order.errors.blank?
        OrderTransactionService.perform_transaction(order)
        render json: order, except: %i[created_at updated_at]
      else
        render json: {}
      end
    end

    private

    def order_side
      params[:side].downcase == 'buy' ? Order.sides[:buy] : Order.sides[:sell]
    end

  end
end