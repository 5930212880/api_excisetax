require 'rubygems'
require 'rest-client'
require 'json'

class FormDataController < ApplicationController

#  before_action :set_form_datum, only: [:show, :update, :destroy]

  # GET /form_data
  #def index
  #  @form_data = FormDatum.all
    
  #  render json: @form_data
  #end

  # GET /form_data/1
  #def show
  #  render json: @form_datum
  #end

  # POST /form_data
#  def create
#    @form_datum = FormDatum.new(form_datum_params)

#    if @form_datum.save
#      render json: @form_datum, status: :created, location: @form_datum
#    else
#      render json: @form_datum.errors, status: :unprocessable_entity
#    end
#  end

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

#  private
    # Use callbacks to share common setup or constraints between actions.
#    def set_form_datum
#      @form_datum = FormDatum.find(params[:id])
#    end

    # Only allow a trusted parameter "white list" through.
#    def form_datum_params
#      params.require(:form_datum).permit(:formreferencenumber, :formeffectivedate1, :cusname, :data)
#    end
    
    def fetch_data
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
      
      value = JSON.parse(response)['ResponseData']['FormInformation']['FormData'].each do |key|
        puts key
      end

      render json: value
      #obj = JSON.parse(response)
      #render json: obj
      #['FormData'][0]['RtnCtlNo']
      

    
      
      
    end
end
