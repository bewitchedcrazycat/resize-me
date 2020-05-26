class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.string :name, null: false
      t.integer :height, null: true
      t.integer :width, null: true
      t.string :url, null: false
      t.string :content_type, null: false
      t.boolean :processed, :default => false

      t.timestamps
    end
  end
end
