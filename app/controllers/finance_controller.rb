class FinanceController < ApplicationController
  def index
    @stocks = Stock.all
  end
end
