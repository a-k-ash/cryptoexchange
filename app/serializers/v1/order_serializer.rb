module V1
  class OrderSerializer < ActiveModel::Serializer
    attributes :order_id, :status, :price, :volume, :traded_volume

    def order_id
      object['id']
    end

  end
end