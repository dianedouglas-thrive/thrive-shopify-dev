class CreateSmartpages < ActiveRecord::Migration[6.0]
  def change
    create_table :smartpages do |t|
      t.references :shop, null: false, foreign_key: true
      t.string :path

      t.timestamps
    end
  end
end
