class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.integer :degrees
      t.string :page
      t.string :icon

      t.timestamps
    end
  end
end
