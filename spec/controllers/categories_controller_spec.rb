require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  it do
    is_expected.to rescue_from(ActiveRecord::RecordNotFound).
      with(:handle_record_not_found)
  end
end