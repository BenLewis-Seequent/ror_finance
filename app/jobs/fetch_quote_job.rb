require 'net/http'
require 'rexml/document'
require 'rexml/xpath'
require 'rexml/xpath_parser'

require 'pstore'

include REXML

COMPANIES = %w(YHOO AAPL GOOG MSFT AMD).freeze


def get_stock_data
  uri_company_part = COMPANIES.join '%22%2C%22'
  uri = URI.parse(
      "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20"+
          "where%20symbol%20in%20(%22#{uri_company_part}%22)&"+
          "diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
  response = Net::HTTP.get_response(uri)
  xml = response.body
  doc = Document.new xml
  XPath.each(doc, '/query/results/quote') do |el|
    company = XPath.first(el, 'Name/text()')
    price = XPath.first(el, 'LastTradePriceOnly/text()')
    yield(company, price)
  end
rescue StandardError => e
  puts e.message
  Error.create(message: e.message)
end

class FetchQuoteJob < ApplicationJob
  queue_as :default

  def perform(*args)
    pstore = PStore.new('fetch.pstore')
    pstore.transaction do
      unless pstore.fetch('recording', true)
        puts 'not recording'
        return
      end
    end

    puts 'fetching'
    get_stock_data do |company, price|
      stock = Stock.find_or_create_by(company: String(company))
      StockPrice.create(price: price, stock_id: stock.id)
    end

    # schedule next recording if its in the past
    pstore.transaction do
      now = Time.now
      next_recording = pstore.fetch('next_recording', now)
      if next_recording <= now
        puts 'scheduling new fetch'
        FetchQuoteJob.set(wait: 1.minutes).perform_later
        pstore['next_recording'] = now + 1.minute
      end
    end
  end
end
