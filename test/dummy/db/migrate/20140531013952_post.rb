class Post < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :author
      t.boolean :active, default: true
      t.text :body

      t.timestamps
    end
  end
end
