namespace :xml do
  desc "Perform Xml::WorkableJob"
  task workable: :environment do
    Xml::WorkableJob.perform_now
  end
end
