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
    require 'rest-client'

    validates :formreferencenumber, :uniqueness => true

    def self.get_api
      #get data api  
      update_date = '20200302' 
      response = RestClient.post 'http://webtest.excise.go.th/EDRestServicesUAT/rtn/InquiryPs0501',{
        "SystemId":"systemid", 
        "UserName":"my_username", 
        "Password":"bbbbb", 
        "IpAddress":"10.11.1.10", 
        "Operation":"1", 
        "RequestData": {
          "FormUpdateDate":"#{update_date}", 
          "ProductCategory":"01"
        } 
      }.to_json, 
      {
        content_type: :json
      }
    end

    # def show_data
    #   json = {}
    #   json[:formreferencenumber] = self.formreferencenumber
    #   json[:formeffectivedate] = self.formeffectivedate
    #   json[:cusname] = self.cusname
    #   json[:data] = self.data
    #   json
    # end 

end
