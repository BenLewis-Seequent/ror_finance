require 'pstore'

namespace :stock do
  desc "Fetches stack prices"
  task fetch: :environment do
    uri = URI.parse("https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20where%20symbol%20in%20(%22YHOO%22%2C%22AAPL%22%2C%22GOOG%22%2C%22MSFT%22)&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
    puts uri
    response = Net::HTTP.get_response(uri)
    xml = response.body
    doc = Document.new xml
    puts doc
    XPath.each(doc, '/query/results/quote') do |el|
      company = XPath.first(el, 'Name/text()')
      price = XPath.first(el, 'LastTradePriceOnly/text()')
      Stock.find_or_create_by(company: String(company)) do |stock|
        stock.price = String(price)
      end
    end
  end

  desc "Produces report"
  task report: :environment do
  end

end
