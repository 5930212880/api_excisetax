
require 'rest-client'
require 'json'

#class ApiCall
 #  def get_api
#        response = RestClient.post 'http://webtest.excise.go.th/EDRestServicesUAT/rtn/InquiryPs0501',{
#            headers: {
#                'Content-Type': 'application/json'
#            },
#            body: { 
#                SystemId:'systemid', 
#                UserName:'my_username', 
#                Password:'bbbbb', 
#                IpAddress:'10.11.1.10', 
#                Operation:'1', 
#                RequestData: {
#                    FormUpdateDate:'20200429', 
#                    ProductCategory:'01'
#            }
#        }
#    }
        
#    end
#end

#api = ApiCall.new 
#api.each do |data|
#    puts "RequestData: #{data.FormCode}"
#end

payload =   {
    "SystemId":"systemid", 
    "UserName":"my_username", 
    "Password":"bbbbb", 
    "IpAddress":"10.11.1.10", 
    "Operation":"1", 
    "RequestData": {
        "FormReferenceNumber":"", 
        "FormEffectiveDateFrom":"", 
        "FormEffectiveDateTo":"", 
        "HomeOfficeId":"",
        "RegId":"",
        "TaxType":"", 
        "TransFrom":"", 
        "FormStatus":"", 
        "FormUpdateDate":"20200429", 
        "ProductCategory":"01"
} 
}

#resource = RestClient::Request.execute(
#    method: :post, url: 'http://webtest.excise.go.th/EDRestServicesUAT/rtn/InquiryPs0501',
#    UserName: 'my_username', Password: 'bbbbb') 

#response = RestClient.post('http://webtest.excise.go.th/EDRestServicesUAT/rtn/InquiryPs0501',
 #   payload)


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
      
      JSON.parse(response)['ResponseData']['FormInformation']['FormData'].each do |v|
        puts RtnCtlNo: v['RtnCtlNo']
        puts FormEffectiveDate: v['FormEffectiveDate']
        puts FormReferenceNumber: v['FormReferenceNumber']
      end

      
      
