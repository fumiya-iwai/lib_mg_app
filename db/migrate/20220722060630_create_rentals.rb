class CreateRentals < ActiveRecord::Migration[6.1]
  def change
    create_table :rentals do |t|
      t.references :book, foreign_key: true
      t.references :user, foreign_key: true
      t.date :rented_date
      t.date :scheduled_return_date
      t.date :returned_date

      t.timestamps
    end

  end
end
