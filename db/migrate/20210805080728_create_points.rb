class CreatePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :points do |t|
      t.references :user
      t.decimal :value, precision: 10, scale: 2, null: false
      t.boolean :expired, default: false

      t.timestamps
    end
  end
end
