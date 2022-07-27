class ChangeAuthorColumn < ActiveRecord::Migration[6.1]
  def up
    remove_column :authors, :first_name, :string
    rename_column :authors, :last_name, :name
  end

  def down
    add_column :authors, :first_name, :string
    rename_column :authors, :name, :last_name
  end
end
