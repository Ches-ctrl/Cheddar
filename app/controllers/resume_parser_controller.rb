class ResumeParserController < ApplicationController
  def create
    # TODO: Update to get resume from the following:
    # current_user.user_details.resumes.first.url
    resume = params[:resume]

    # Call OpenAI service
    response = Openai.call(resume)

    # Return response
    render json: response

    # Auto-fill user_details with JSON response
    # TODO: Add error handling
  end
end
