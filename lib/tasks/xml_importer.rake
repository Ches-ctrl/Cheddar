namespace :xml do
  desc "Import jobs from Workable XML feed"
  task workable: :environment do
    puts "Import jobs from Workable XML feed : Started"
    Importer::Xml::WorkableJob.new.perform
  end
end
