require 'rest-client'
require 'json'

class FormDataController < ApplicationController

 before_action :find_by_formreferencenumber, only: [:save_form_product_source, :inquiry_form_product_checklist_sou, :inquiry_form_product_checklist_des]

  def updatedate
  end

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
  def save_form_product_source #ส่งหมายเลขทะเบียนรถ/seal/maker
    # seacrh = FormDatum.find_by(formreferencenumber: params[:formreferencenumber])

    if @formref.signflag == '2'
      @listcheck = @formref.data['GoodsListCheck']['GoodsEntry'].map do |v| 
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
        FormReferenceNumber: @formref.formreferencenumber,
        FormEffectiveDate: @formref.formeffectivedate.strftime('%Y%m%d'),
        OffCode: @formref.data['HomeOfficeId'],
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
      render json: { ResponseMessage: 'ไม่สามารถบันทึกข้อมูลได้' } 
    end
  end

  #---- POST /form_data/inquirychecklist/[:formreferencenumber] ----#
  def inquiry_form_product_checklist_sou #ดึงรายชื่อผู้เซ็น ต้นทาง signflag = 2  
    # formref = FormDatum.find_by(formreferencenumber: params[:formreferencenumber])

    @productchecklistsou = {
      SystemId: "systemid",
      UserName: "my_username",
      Password: "bbbbb",
      IpAddress: "10.11.1.10",
      Operation: "1",
      RequestData: { FormCode: "PS28",
      FormReferenceNumber: @formref.formreferencenumber,
      FormEffectiveDate: @formref.formeffectivedate.strftime('%Y%m%d'),
      OffCode: @formref.data['HomeOfficeId'],
      ActionType: "1"
      }
    }.to_json

    inquiryformchecklistsou = RestClient.post 'http://webtest.excise.go.th/EDRestServicesUAT/rtn/InquiryFormProductCheckList',
      @productchecklistsou, { content_type: :json }

    render json: inquiryformchecklistsou
  end

  #---- POST /form_data/inquirychecklist/[:formreferencenumber] ----#
    def inquiry_form_product_checklist_des #ดึงรายชื่อผู้เซ็น ปลายทาง signflag = 2  
      # checklist = FormDatum.find_by(formreferencenumber: params[:formreferencenumber])

      @productchecklistdes = {
        SystemId: "systemid",
        UserName: "my_username",
        Password: "bbbbb",
        IpAddress: "10.11.1.10",
        Operation: "1",
        RequestData: { FormCode: "PS28",
        FormReferenceNumber: @formref.formreferencenumber,
        FormEffectiveDate: @formref.formeffectivedate.strftime('%Y%m%d'),
        OffCode: @formref.data['HomeOfficeId'],
        ActionType: "2"
        }
      }.to_json

      inquiryformchecklistdes = RestClient.post 'http://webtest.excise.go.th/EDRestServicesUAT/rtn/InquiryFormProductCheckList',
        @productchecklistdes, { content_type: :json }

      render json: inquiryformchecklistdes
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

private
#     # Use callbacks to share common setup or constraints between actions.
    def find_by_formreferencenumber
      @formref = FormDatum.find_by(formreferencenumber: params[:formreferencenumber])
    end

#     # Only allow a trusted parameter "white list" through.
#     def form_datum_params
#      params.require(:form_datum).permit(:formeffectivedate)
#     end

   
end
