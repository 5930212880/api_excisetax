# == Schema Information
#
# Table name: form_data
#
#  id                  :bigint           not null, primary key
#  cusname             :string
#  data                :jsonb
#  formeffectivedate   :date
#  formreferencenumber :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_form_data_on_formreferencenumber  (formreferencenumber) UNIQUE
#
class FormDatum < ApplicationRecord
    validates :formeffectivedate, length: { is: 8 }
    validates :formreferencenumber, length: { is: 14 }
    
end
