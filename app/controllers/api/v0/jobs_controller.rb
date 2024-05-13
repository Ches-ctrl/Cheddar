module Api
  module V0
    class JobsController < ApplicationController
      skip_before_action :verify_authenticity_token, only: :add_job
      before_action :authenticate_with_api_key
      before_action :verify_request_origin
      before_action :authenticate_user!, only: :add_job

      def add_job
        posting_url = params[:posting_url]
        p "posting_url: #{posting_url}"

        if posting_url
          render json: { message: 'Posting URL sent successfully' }, status: :ok
        else
          render json: { message: 'Post API connected but no posting_url' }, status: :ok
        end

        # if CreateJobFromUrl.call(posting_url)
        #   render json: { message: 'Job added successfully' }, status: :ok
        # else
        #   render json: { error: 'Failed to add job' }, status: :unprocessable_entity
        # end
      end

      private

      def authenticate_with_api_key
        api_key = request.headers['X-Api-Key']
        render json: { error: 'Unauthorized API key' }, status: :unauthorized unless valid_api_key?(api_key)
      end

      def valid_api_key?(api_key)
        api_key == ENV['CHROME_EXTENSION_API_KEY']
      end

      def verify_request_origin
        origin = request.headers['Origin']
        render json: { error: 'Unauthorized origin' }, status: :unauthorized unless valid_origin?(origin)
      end

      def valid_origin?(origin)
        origin == ENV['CHROME_EXTENSION_ORIGIN']
      end
    end
  end
end
