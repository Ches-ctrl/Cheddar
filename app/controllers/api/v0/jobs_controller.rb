module Api
  module V0
    class JobsController < ApplicationController
      skip_before_action :verify_authenticity_token, only: :add_job
      skip_before_action :authenticate_user!, only: :add_job

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
    end
  end
end
