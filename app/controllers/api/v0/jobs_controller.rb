module Api
  module V0
    class JobsController < ApplicationController
      def add_job
        job_url = params[:job_url]
        p job_url
        render json: { message: 'Job added successfully' }, status: :ok

        # if CreateJobFromUrl.call(job_url)
        #   render json: { message: 'Job added successfully' }, status: :ok
        # else
        #   render json: { error: 'Failed to add job' }, status: :unprocessable_entity
        # end
      end
    end
  end
end
