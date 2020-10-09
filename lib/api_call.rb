
require 'rest-client'
require 'json'


      update_date = '20200729' 
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
      
      # # @data = JSON.parse(response)['ResponseData']['FormInformation']['FormData']

      # # JSON.parse(response)['ResponseData']['FormInformation']['FormData'].map do |v|
      # #   puts FormReferenceNumber: v['FormReferenceNumber'], TransportName: v['TransportName1'], FormEffectiveDate: v['FormEffectiveDate'], OffCode: "010400", Transfrom: "1", Remark: ""
      # #   v['GoodsListPart2']['GoodsEntry'].map do |b|
      # #       puts ProductCode: b['ProductCode'], CategoryCode1: "Alh", GoodsInformation: { UnitCode: b['UnitCode'], Amount: b['GoodsNum']}
      # #       puts UnitCode: b['UnitCode'], Amount: b['GoodsNum'], SeqNo: b['SeqNo']
      # #   end
      # end


       # data = JSON.parse(formeffectivedate)['ResponseData']['FormInformation']['FormData'].map do |v|
    #   v['GoodsListPart1']['GoodsEntry'].map do |b|
    #       ProductCode: b['ProductCode'], CategoryCode1: "Alh"
    #       UnitCode: b['UnitCode'], Amount: b['GoodsNum'], SeqNo: b['SeqNo'], TransportName: b['TransportName']
    #   end
    # end

    a = [1,2,3]

    
      a.map do |v|
        
      end
  




    


      

     

      
      
