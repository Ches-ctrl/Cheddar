require 'rails_helper'

RSpec.describe Api::V0::JobsController, type: :controller do
  describe 'POST #add_job' do
    it 'returns a successful response' do
      post :add_job
      expect(response).to have_http_status(:ok)
    end

    it 'returns a JSON response with a success message' do
      post :add_job
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('Job added successfully')
    end
  end
end
