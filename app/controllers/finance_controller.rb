require 'sidekiq/api'

require 'pstore'

class FinanceController < ApplicationController
  def index
    @stocks = Stock.all
    @errors = Error.last_errors(5)
  end

  def update
    record = params[:recording]
    if record.nil?
      head :bad_request
    else
      pstore = PStore.new('fetch.pstore')
      pstore.transaction do
        pstore['recording'] = record == 'true'
      end
      if record == 'true'
        FetchQuoteJob.perform_later
      else
        Sidekiq::Queue.new.each do |job|
          puts job.klass
          puts job.args
          puts job.jid
          job.delete
        end
      end
      respond_to do |format|
        format.html { redirect_to '/finance', notice: 'Stock updated.' }
        format.json { head :no_content }
      end
    end
  end

  def now
    FetchQuoteJob.perform_now
    @stocks = Stock.all
  end
end
