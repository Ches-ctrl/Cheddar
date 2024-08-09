namespace :tests do
  # Call this with e.g. rake "tests:end_to_end[https://apply.workable.com/starling-bank/j/60ACE7278C, 15]"
  desc "Conduct end-to-end tests on a given url"
  task :end_to_end, %i[url_string sleeptime] => :environment do |_, args|
    ENV['URL_FOR_TESTING'] = args[:url_string]
    ENV['SLEEPTIME'] = args[:sleep_time]

    RSpec::Core::RakeTask.new(:spec_task) do |t|
      t.pattern = 'spec/features/apply_to_job_spec.rb'
    end

    Rake::Task['spec_task'].invoke
  end
end
