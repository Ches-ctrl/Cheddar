class JobApplicationsController < ApplicationController
  def edit
    load_application_process
    load_job_application
  end

  def update
    load_application_process
    load_job_application
    assign_job_application_params
    persist_job_application
  end

  private

  def application_process_scope
    current_user.application_processes
  end

  def assign_job_application_params
    @job_application.assign_attributes(job_application_params)
  end

  def load_application_process
    @application_process = ApplicationProcessesQuery.call(application_process_scope)
                                                    .find(params[:application_process_id])
  end

  def load_job_application
    @job_application = @application_process.job_applications.find(params[:id])
  end

  def job_application_params
    params.require(:job_application).permit(:application_process_id, :id, { additional_info: {} })
  end

  def next_step_path
    job_application_ids = @application_process.job_application_ids
    index = job_application_ids.index(params[:id].to_i)

    if index.to_i < job_application_ids.length - 1
      edit_application_process_job_application_path(@application_process, job_application_ids[index + 1])
    else
      application_process_overview_path
    end
  end

  def persist_job_application
    if save_job_application
      redirect_to next_step_path, notice: 'Job successfully saved!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def save_job_application = @job_application.save
end
