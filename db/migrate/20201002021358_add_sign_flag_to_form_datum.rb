class AddSignFlagToFormDatum < ActiveRecord::Migration[5.2]
  def change
    add_column :form_data, :signflag, :string
  end
end
