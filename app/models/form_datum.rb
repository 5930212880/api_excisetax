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

    validates :formreferencenumber, length: { is: 14 }, :uniqueness => true
    
    #    api_parse = JSON.parse(response)
    #    data = api_parse['ResponseData']['FormInformation']['FormData'].map do |value|
    #        api_new = FormDatum.new
    #        api_new.formreferencenumber = value['FormReferenceNumber']
    #        api_new.formeffectivedate = value['FormEffectiveDate']
    #        api_new.cusname = value['CusName']
    #        api_new.data = value
    #        api_new.save
    #        api_new
    #    end
    #    data.select(&:persisted?)
    #end

    
      update_date = '20200414' 
      response = RestClient.post 'http://webtest.excise.go.th/EDRestServicesUAT/rtn/InquiryPs0501',
      {
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

      api_data = JSON.parse(response)['ResponseData']['FormInformation']['FormData']
      
        api_data.each do |value|
            if FormDatum.exists?(['formreferencenumber LIKE ?',"%#{value['FormReferenceNumber']}%"])
                FormDatum.update(
                    cusname: value['CusName'].to_s,
                    formeffectivedate: value['FormEffectiveDate'],
                    formreferencenumber: value['FormReferenceNumber'],
                    data: value
                )
            else    
                FormDatum.create!(
                    cusname: value['CusName'].to_s,
                    formeffectivedate: value['FormEffectiveDate'],
                    formreferencenumber: value['FormReferenceNumber'].to_s,
                    data: value
                )
            end    
        end

end
