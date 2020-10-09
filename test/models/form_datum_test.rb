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
require 'test_helper'

class FormDatumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
