namespace :testing do
  desc "Conduct end-to-end tests on a given url"
  task :url, [:url_string] => :environment do |_, args|
    ENV['URL_FOR_TESTING'] = args[:url_string]

    RSpec::Core::RakeTask.new(:spec_task) do |t|
      t.pattern = 'spec/features/apply_to_job_spec.rb'
    end

    Rake::Task['spec_task'].invoke
  end

  # desc "Conduct end-to-end tests on a given url"
  # task url: :environment do
  #   ENV['URL_FOR_TESTING'] = prompt_user

  #   RSpec::Core::RakeTask.new(:spec_task) do |t|
  #     t.pattern = 'spec/features/apply_to_job_spec.rb'
  #   end

  #   Rake::Task['spec_task'].invoke
  # end

  def prompt_user
    response = nil
    until response
      puts "Please enter a valid job posting url:"
      response = $stdin.gets.chomp
    end

    response
  end
end
