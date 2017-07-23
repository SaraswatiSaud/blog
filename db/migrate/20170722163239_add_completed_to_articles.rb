class AddCompletedToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :completed, :boolean, default: false
  end
end
