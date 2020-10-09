# == Schema Information
#
# Table name: form_data
#
#  id                  :bigint           not null, primary key
#  cusname             :string
#  data                :jsonb
#  formeffectivedate   :date
#  formreferencenumber :string
#  signflag            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_form_data_on_formreferencenumber  (formreferencenumber) UNIQUE
#
class FormDatum < ApplicationRecord

    validates :formreferencenumber, length: { maximum: 14 }, :uniqueness => true

    def show_data
      json = {}
      json[:formreferencenumber] = self.formreferencenumber
      json[:formeffectivedate] = self.formeffectivedate
      json[:cusname] = self.cusname
      json[:data] = self.data['Tin'],self.data['CusId']
      json
    end 

end
