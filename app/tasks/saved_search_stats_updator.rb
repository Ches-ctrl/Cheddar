# frozen_string_literal: true

class SavedSearchStatsUpdator < ApplicationTask
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
    @saved_search
  end

  def process
    fetch_jobs
    assign_search_stats
    persist_saved_search
  end

  ###
  def assign_search_stats
    @saved_search.assign_attributes(jobs_count:, job_last_updated_at:)
  end

  def fetch_jobs
    @jobs = OpportunitiesFetcher.call(Job.all, @params)
  end

  def jobs_count
    @jobs.length
  end

  def job_last_updated_at
    @jobs.max_by(&:updated_at).updated_at
  end

  def persist_saved_search = @saved_search.save
end
