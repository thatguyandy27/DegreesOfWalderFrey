class AddTypeToRelationships < ActiveRecord::Migration
  def change
    add_column :characters, :priority, :integer
  end
end
