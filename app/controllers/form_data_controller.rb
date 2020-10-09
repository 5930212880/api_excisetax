require 'rest-client'
require 'json'

class FormDataController < ApplicationController

#  before_action :set_form_datum, only: [:show, :update, :destroy]

  def all
    render json: FormDatum.all
  end

  #---- GET /form_data/formeffectivedate ----#
  def inquiry
    url = params[:formeffectivedate]
    
    data = RestClient.post 'http://webtest.excise.go.th/EDRestServicesUAT/rtn/InquiryPs0501',{
       SystemId:"systemid", 
       UserName:"my_username", 
       Password:"bbbbb", 
       IpAddress:"10.11.1.10", 
       Operation:"1", 
       RequestData: {
        FormReferenceNumber: "", 
        FormEffectiveDateFrom: "", 
        FormEffectiveDateTo: "", 
        HomeOfficeId: "",
        FormStatus: "A", 
        FormUpdateDate:"#{url}", 
        ProductCategory:"01"
       } 
     }.to_json, 
     {
       content_type: :json
     }
    
    if JSON.parse(data)['ResponseCode'] != "OK"
      render json: { status: 404, error: "Not Found" }, status: :not_found
    else
    #parse json
      api_data = JSON.parse(data)['ResponseData']['FormInformation']['FormData']

    #map data to db
      api_data.each do |value|
        if value['SignFlag'] == '2'
          if FormDatum.exists?(['formreferencenumber LIKE ?',"%#{value['FormReferenceNumber']}%"])
              FormDatum.update(
                  cusname: value['CusName'],
                  formeffectivedate: value['FormEffectiveDate'],
                  formreferencenumber: value['FormReferenceNumber'],
                  signflag: value['SignFlag'],
                  data: value
              )
          else 
              FormDatum.create!(
                  cusname: value['CusName'],
                  formeffectivedate: value['FormEffectiveDate'],
                  formreferencenumber: value['FormReferenceNumber'],
                  signflag: value['SignFlag'],
                  data: value
              )
          end    
        else
          # render json: { ResponseMessage: "Error , SignFlag = #{value['SignFlag']}" }
        end
      end
      render json: FormDatum.all
    end
  end
  
  #---- GET /form_data/formreferencenumber ----#
  def show
    form_data = FormDatum.find_by(formreferencenumber: params[:formreferencenumber])
    if form_data.present?
      render json: form_data
    else
      render json: { status: 404, error: "Not Found" }, status: :not_found
    end
  end

  #---- POST /form_data/saveproduct/[:formreferencenumber] ----#
  def save_form_product_source
    seacrh = FormDatum.find_by(formreferencenumber: params[:formreferencenumber])

    if seacrh.signflag == '2'
      @listcheck = seacrh.data['GoodsListCheck']['GoodsEntry'].map do |v| 
        { UnitCode: v['UnitCode'], 
          Amount: v['SouAmount'], 
          SeqNo: v['SeqNo'], 
          TransportName: v['SouTransportName'], 
          SealNo: v['SouSealNo'], 
          SealAmount: v['SouSealAmount'], 
          Marker: v['SouMarker'], 
          GoodsInformation: { 
            ProductCode: v['ProductCode'], 
            CategoryCode1: v['BrandMainCode'], 
            CategoryCode2: v['BrandSecondCode'], 
            CategoryCode3: v['ModelCode'], 
            CategoryCode4: v['SizeCode'], 
            CategoryCode5: v['DegreeCode']
          } 
        }
      end 

      @requestdata = { 
        SystemId: "systemid",
        UserName: "my_username",
        Password: "bbbbb",
        IpAddress: "10.11.1.10",
        Operation: "1",
        RequestData: { FormCode: "PS28",
        FormReferenceNumber: seacrh.formreferencenumber,
        FormEffectiveDate: seacrh.formeffectivedate.strftime('%Y%m%d'),
        OffCode: seacrh.data['HomeOfficeId'],
        TransFrom: "1",
        Remark: "",
        GoodsList: {
          GoodsEntry: @listcheck
        }
        } 
      }.to_json

      saveproduct = RestClient.post 'http://webtest.excise.go.th/EDRestServicesUAT/rtn/SaveFormProductSource', 
        @requestdata, { content_type: :json }
      
      render json: saveproduct

    else
      render json: { ResponseMessage: "ไม่สามารถบันทึกได้ signflag = #{seacrh.signflag}" }
    end
  end

  #---- POST /form_data/ ----#
    def inquiry_form_product_checklist
      checklist = FormDatum.find_by(formreferencenumber: params[:formreferencenumber])

      @productchecklist = {
        SystemId: "systemid",
        UserName: "my_username",
        Password: "bbbbb",
        IpAddress: "10.11.1.10",
        Operation: "1",
        RequestData: { FormCode: "PS28",
        FormReferenceNumber: checklist.formreferencenumber,
        FormEffectiveDate: checklist.formeffectivedate.strftime('%Y%m%d'),
        OffCode: checklist.data['HomeOfficeId'],
        ActionType: "2"
        }
      }.to_json

      inquiryformchecklist = RestClient.post 'http://webtest.excise.go.th/EDRestServicesUAT/rtn/InquiryFormProductCheckList',
        @productchecklist, { content_type: :json }

      render json: inquiryformchecklist
    end

  # POST /form_data
  #def create
  #  @form_datum = FormDatum.new(form_datum_params)

  #  if @form_datum.save
  #    render json: @form_datum, status: :created, location: @form_datum
  #  else
  #    render json: @form_datum.errors, status: :unprocessable_entity
  #  end
  #end

  # PATCH/PUT /form_data/1
#  def update
#    if @form_datum.update(form_datum_params)
#      render json: @form_datum
#    else
#      render json: @form_datum.errors, status: :unprocessable_entity
#    end
#  end

  # DELETE /form_data/1
#  def destroy
#    @form_datum.destroy
#  end

# private
#     # Use callbacks to share common setup or constraints between actions.
#     #def set_form_datum
#     #  @form_datum = FormDatum.find(params[:id])
#     #end

#     # Only allow a trusted parameter "white list" through.
#     def form_datum_params
#      params.require(:form_datum).permit(:formeffectivedate)
#     end

   
end
