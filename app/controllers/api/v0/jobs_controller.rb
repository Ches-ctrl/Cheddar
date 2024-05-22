module Api
  module V0
    class JobsController < ApplicationController
      skip_before_action :verify_authenticity_token, only: :add_job
      before_action :authenticate_with_api_key
      before_action :verify_request_origin
      before_action :authenticate_user!

      def add_job
        posting_url = params[:posting_url]

        if posting_url.present?
          process_job_posting(posting_url)
        else
          render json: { message: 'Post API connected but no posting_url' }, status: :bad_request
        end
      end

      private

      def authenticate_with_api_key
        api_key = request.headers['X-Api-Key']
        render json: { error: 'Unauthorized API key' }, status: :unauthorized unless valid_api_key?(api_key)
      end

      def valid_api_key?(api_key)
        api_key == ENV.fetch('CHROME_EXTENSION_API_KEY')
      end

      def verify_request_origin
        origin = request.headers['Origin']
        render json: { error: 'Unauthorized origin' }, status: :unauthorized unless valid_origin?(origin)
      end

      def valid_origin?(origin)
        origin == ENV.fetch('CHROME_EXTENSION_ORIGIN')
      end

      def process_job_posting(posting_url)
        p "Processing job posting: #{posting_url}"
        render json: { message: 'Job added successfully' }, status: :ok

        # if CreateJobFromUrl.perform_later(posting_url)
        #   render json: { message: 'Job creation queued successfully' }, status: :ok
        # else
        #   render json: { error: 'Failed to queue job creation' }, status: :unprocessable_entity
        # end
      end
    end
  end
end
