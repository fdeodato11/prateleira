class AddScraperFieldsToProducts < ActiveRecord::Migration[8.0]
  def change
    change_table :products do |t|
      t.string :source
      t.string :external_url
      t.decimal :original_price, precision: 10, scale: 2
      t.float :rating
      t.integer :reviews_count, default: 0
    end

    add_index :products, :source
  end
end
