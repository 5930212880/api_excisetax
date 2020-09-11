require 'test_helper'

class FormDataControllerTest < ActionDispatch::IntegrationTest
  setup do
    @form_datum = form_data(:one)
  end

  test "should get index" do
    get form_data_url, as: :json
    assert_response :success
  end

  test "should create form_datum" do
    assert_difference('FormDatum.count') do
      post form_data_url, params: { form_datum: { cusname: @form_datum.cusname, data: @form_datum.data, formeffectivedate1: @form_datum.formeffectivedate1, formreferencenumber: @form_datum.formreferencenumber } }, as: :json
    end

    assert_response 201
  end

  test "should show form_datum" do
    get form_datum_url(@form_datum), as: :json
    assert_response :success
  end

  test "should update form_datum" do
    patch form_datum_url(@form_datum), params: { form_datum: { cusname: @form_datum.cusname, data: @form_datum.data, formeffectivedate1: @form_datum.formeffectivedate1, formreferencenumber: @form_datum.formreferencenumber } }, as: :json
    assert_response 200
  end

  test "should destroy form_datum" do
    assert_difference('FormDatum.count', -1) do
      delete form_datum_url(@form_datum), as: :json
    end

    assert_response 204
  end
end
