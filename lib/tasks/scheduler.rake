desc "Perform CallJobApiJob (Coresignal) task"
task :call_job_api => :environment do
  p "Performing CallJobApiJob..."
  CallJobApiJob.perform_later
  p "Done with CallJobApiJob."
end
