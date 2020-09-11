class CreateFormData < ActiveRecord::Migration[5.2]
  def change
    create_table :form_data do |t|
      t.string :formreferencenumber
      t.date :formeffectivedate
      t.string :cusname
      t.jsonb :data

      t.timestamps
    end
    add_index :form_data, :formreferencenumber, unique: true
  end
end
