require './app/helpers/rake_helpers'

namespace :tests do
  # Call this with e.g. rake "tests:end_to_end[https://apply.workable.com/starling-bank/j/60ACE7278C, 15]"
  # It takes a required argument, the posting_url of the job to be tested.
  # There's an optional argument, which is a number of seconds to pause after completing the Cheddar form to allow for manual review. Default is 0.
  # The rake task runs apply_to_job_spec.rb. That file has its own comments to explain what it does.
  desc "Conduct end-to-end tests on a given url"
  task :end_to_end, %i[url_string sleep_time] => :environment do |_, args|
    ENV['URL_FOR_TESTING'] = args[:url_string]
    ENV['SLEEP_TIME'] = args[:sleep_time]

    RSpec::Core::RakeTask.new(:spec_task) do |t|
      t.pattern = 'spec/features/apply_to_job_spec.rb'
    end

    Rake::Task[:spec_task].invoke
  end

  desc "Conduct end-to-end batch testing"
  task batch_test: :environment do
    include RakeHelpers
    prompt_for_ats
  end
end
