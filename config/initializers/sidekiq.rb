Sidekiq.configure_client do |config|
  Rails.application.config.after_initialize do
    FetchQuoteJob.perform_later
  end
end