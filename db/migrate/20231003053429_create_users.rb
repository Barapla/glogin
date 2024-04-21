class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :picture_url
      t.string :uid # Google uid
      t.string :provider # Google provider

      t.timestamps
    end
  end
end
