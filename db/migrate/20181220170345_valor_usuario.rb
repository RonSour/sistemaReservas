class ValorUsuario < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :user_role, :integer, default:0;
  end
end
