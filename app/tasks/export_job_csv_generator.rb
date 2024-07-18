# frozen_string_literal: true

class ExportJobCsvGenerator < ApplicationTask
  def initialize(saved_search)
    @saved_search = saved_search
    @params = saved_search.params.symbolize_keys
  end

  def call
    return false unless processable

    process
  end

  private

  def processable
    @saved_search && @params.present?
  end

  def process
    fetch_jobs
    generate_csv
    attach_csv
  end

  ###

  def generate_csv
    @tempfile = Tempfile.new(["export_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}_#{@saved_search.id}", '.csv']).tap do |file|
      CSV.open(file, 'wb') do |csv|
        csv << %w[id title description created_at] # CSV Header Row
        @jobs.each do |job|
          csv << [job.id, job.title, job.description, job.created_at]
        end
      end
    end
  end

  def attach_csv
    @saved_search.export.attach(io: @tempfile, filename:)
  end

  def fetch_jobs
    @jobs = OpportunitiesFetcher.call(Job.all, @params)
  end

  def filename
    @tempfile.path.split('/').last.split('.csv').first
  end
end
