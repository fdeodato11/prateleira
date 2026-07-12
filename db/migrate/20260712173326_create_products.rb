class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false, default: 0.0
      t.integer :stock_quantity, null: false, default: 0
      t.string :sku, null: false
      t.integer :status, null: false, default: 0
      t.datetime :discarded_at
      t.boolean :featured, null: false, default: false
      t.decimal :weight, precision: 8, scale: 2
      t.json :tags

      t.timestamps
    end
    add_index :products, :sku, unique: true
    add_index :products, [ :category_id, :status ]
    add_index :products, [ :status, :price ]
    add_index :products, :discarded_at
    add_index :products, :name, type: :fulltext
    add_index :products, [ :name, :description ], type: :fulltext, name: "idx_products_on_name_and_description_fulltext"
  end
end
