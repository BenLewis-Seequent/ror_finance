class Stock < ApplicationRecord
  self.table_name = 'stock'

  def last_prices(n)
    StockPrice.where(stock_id: self.id).order(created_at: :desc).limit(n)
  end
end
