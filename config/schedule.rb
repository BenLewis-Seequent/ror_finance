set :environment, "development"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}
env :PATH, ENV['PATH']

every 1.hour do
  rake "stock:report"
end
