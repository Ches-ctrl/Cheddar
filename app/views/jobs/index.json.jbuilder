json.array! @jobs do |job|
  json.id job.id
  json.title job.title
  json.name job.company.name
  json.job_posting_url job.job_posting_url
  json.job_description job.job_description
  json.api_url job.api_url
  json.office job.office
  json.remote_only job.remote_only
  json.hybrid job.hybrid
  json.latitude job.latitude
  json.longitude job.longitude
  json.city job.city
  json.role job.role
end
