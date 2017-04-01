require 'pstore'

namespace :stock do
  desc "Produces report"
  task report: :environment do
    now = Time.now
    filename = "#{format('%04d', now.year)}_#{format('%02d', now.month)}_" \
               "#{format('%02d', now.day)}_#{format('%02d', now.hour)}"
    File.open("report/#{filename}.txt", 'w') do |f|
      f.write("Stock Report generated at #{now}\n")
      get_stock_data do |company, price|
        f.write("#{company}\t #{price}\n")
      end
    end
  end
end
