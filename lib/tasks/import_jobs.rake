namespace :importer do
  namespace :xml do
    desc "Import jobs from Workable"
    task import_jobs: :environment do
      Importer::Xml::WorkableParserJob.perform_now
      puts "\nJobs imported successfully."
    end
  end
end
