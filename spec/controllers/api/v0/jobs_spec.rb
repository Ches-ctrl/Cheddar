require 'rails_helper'

RSpec.describe Api::V0::JobsController, type: :controller do
  describe 'POST #add_job' do
    context 'with valid API key and origin' do
      before do
        request.headers['X-Api-Key'] = ENV['CHROME_EXTENSION_API_KEY']
        request.headers['Origin'] = ENV['CHROME_EXTENSION_ORIGIN']
      end

      it 'returns a successful response' do
        post :add_job, params: { posting_url: 'https://example.com/job' }
        expect(response).to have_http_status(:ok)
      end

      it 'returns a JSON response with a success message' do
        post :add_job, params: { posting_url: 'https://example.com/job' }
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Posting URL sent successfully')
      end
    end

    context 'with invalid API key' do
      before do
        request.headers['X-Api-Key'] = 'invalid_api_key'
        request.headers['Origin'] = ENV['CHROME_EXTENSION_ORIGIN']
      end

      it 'returns an unauthorized response' do
        post :add_job
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a JSON response with an error message' do
        post :add_job
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Unauthorized API key')
      end
    end

    context 'with invalid origin' do
      before do
        request.headers['X-Api-Key'] = ENV['CHROME_EXTENSION_API_KEY']
        request.headers['Origin'] = 'invalid_origin'
      end

      it 'returns an unauthorized response' do
        post :add_job
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a JSON response with an error message' do
        post :add_job
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Unauthorized origin')
      end
    end
  end
end
