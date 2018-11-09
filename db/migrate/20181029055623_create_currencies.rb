class CreateCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :currencies do |t|
      t.string :currency_type
      t.float :currency_value
      t.date :forcing_date

      t.timestamps
    end
  end
end
