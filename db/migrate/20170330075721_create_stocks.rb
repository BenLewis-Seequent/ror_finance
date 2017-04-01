class CreateStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :stock do |t|
      t.string :company
      t.timestamps
    end

    create_table :stock_price do |t|
      t.string :price
      t.references(:stock)
      t.timestamps
    end

    create_table :error do |t|
      t.text :message
      t.timestamps
    end
  end
end
