class InitialCreate < ActiveRecord::Migration
  def change
    create_table :resources do |t|
        t.string :name
        t.text :description
    end

    create_table :bookings do |t|
        t.belongs_to :resource
        t.datetime :start_date
        t.datetime :end_date
        t.string :status
        t.string :user
    end
  end
end
