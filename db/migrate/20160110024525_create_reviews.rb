class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :book, index: true
      t.references :user, index: true
      t.text :body

      t.timestamps null: false
    end
    add_foreign_key :reviews, :books
    add_foreign_key :reviews, :users
  end
end
