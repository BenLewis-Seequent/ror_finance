class Stock < ApplicationRecord
  def self.get_or_create(company, price)
    puts company
    @stock = find_by_company(company)
    if @stock == null
      @stock = Stock.create(company: company, price: price)
    else
      @stock.price = price
      @stock.save
    end
  end
end
