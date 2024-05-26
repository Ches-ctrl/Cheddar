puts "How many jobs would you like to seed?"

response = nil
until response do
  puts "Please enter a valid integer between 1 and 500:"
  response = gets.chomp
  if response == 'run updater'
    UpdateExistingCompanyJobs.perform_later
    exit
  else
    response = response.to_i
    response = nil if response.zero? || response > 500
  end
end

puts "-------------------------------------"

puts "First deleting previous (1) users, (2) jobs, (3)companies, (4) ATS Formats, (5) Applicant Tracking Systems, (6) Locations, (7) Countries, (8) Roles..."
puts "Are you sure you want to delete all data? (Y/N)"

confirmation = gets.chomp.downcase
if confirmation == 'y'
  JobApplication.destroy_all
  puts "Deleted all job applications."
  User.destroy_all
  puts "Deleted all users."
  Job.destroy_all
  puts "Deleted all jobs."
  Company.destroy_all
  puts "Deleted all companies."
  ApplicantTrackingSystem.destroy_all
  puts "Deleted all applicant tracking systems."
  Location.destroy_all
  puts "Deleted all locations."
  Country.destroy_all
  puts "Deleted all countries."
  Role.destroy_all
  puts "Data deleted successfully!"
else
  puts "Deletion cancelled."
end

puts "Do you want to continue seeding the database? (Y/N)"
confirmation = gets.chomp.downcase
exit if confirmation == 'n'

puts "-------------------------------------"

puts "Creating new Applicant Tracking Systems..."

Rake::Task['import_csv:applicant_tracking_systems'].invoke

puts "Created #{ApplicantTrackingSystem.count} ATSs"

puts "-------------------------------------"

greenhouse_companies = [
  "cleoai",
  "ably30",
  "11fs",
  "clearscoretechnologylimited",
  "codepath",
  "copperco",
  "coreweave",
  "cultureamp",
  "deliveroo",
  "doctolib",
  "epicgames",
  "figma",
  "forter",
  "geniussports",
  "getir",
  "gomotive",
  "grammarly",
  "intercom",
  "janestreet",
  "knowde",
  "narvar",
  "niantic",
  "opendoor"
]

puts "Creating new roles..."

roles = %w(front_end back_end full_stack dev_ops qa_test_engineer mobile data_engineer)
roles.each { |role| Role.create(name: role) }

puts "Created #{Role.count} roles"

puts "-------------------------------------"

puts "Preparing to re-seed database with #{response} Greenhouse jobs...\n"

puts "Creating new jobs via Greenhouse API..."

defunct_urls = []

puts "\nBuilding a list of job urls from the following companies:"
puts "This may take a little while, worry not young padawan..."

relevant_job_urls = Importer::GetRelevantJobUrls.new(greenhouse_companies).fetch_jobs
jobs_to_seed = relevant_job_urls.shuffle.take(response)

# jobs_to_seed = [
#   "https://boards.greenhouse.io/11fs/jobs/4296543101",
# ]

jobs_to_seed.each do |url|
  Url::CreateJobFromUrl.new(url).create_company_then_job
end

puts "Created #{Job.count} jobs..."

puts "-------------------------------------"

puts "Creating users..."

Rake::Task['import_csv:users'].invoke

puts "Created #{User.count} users..."

puts "-------------------------------------"

5.times do |_application|
  JobApplication.create(
    status: "Pre-test",
    user_id: User.all.sample.id,
    job_id: Job.all.sample.id
  )
  puts "Created job application"
end

5.times do |_application|
  JobApplication.create(
    status: "Applied",
    user_id: User.find_by(first_name: "Charlotte", last_name: "Boyd").id,
    job_id: Job.all.sample.id
  )
  puts "Created job application"
end

puts "Created #{JobApplication.count} job applications..."

puts "-------------------------------------"

puts ApplicantTrackingSystem.all
puts ApplicantTrackingSystem.count
puts "-------------------------------------"
puts Company.all
puts Company.count
puts "-------------------------------------"
puts Role.all
puts Role.count
puts "-------------------------------------"
puts Job.all
puts Job.count
puts "-------------------------------------"
puts User.all
puts User.count
puts "-------------------------------------"
puts JobApplication.all
puts JobApplication.count
puts "-------------------------------------"
puts Country.all
puts Country.count
puts "-------------------------------------"
puts Location.all
puts Location.count
puts "-------------------------------------"

puts "Done!\n"

puts "The following urls refer to jobs that are no longer live and should be deleted from the seedfile:" unless defunct_urls.empty?
defunct_urls.each do |url|
  puts url
end
