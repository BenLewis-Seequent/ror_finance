class Error < ApplicationRecord
  self.table_name = 'error'

  def self.last_errors(n)
    Error.order(created_at: :desc).limit(n)
  end
end