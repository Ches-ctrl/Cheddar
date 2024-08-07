json.array! @jobs do |job|
  json.id job.id
  json.title job.title
  json.name job.company.name
  json.posting_url job.posting_url
  json.description job.description
  json.api_url job.api_url
  json.office job.office
  json.remote job.remote
  json.hybrid job.hybrid
  json.latitude job.latitude
  json.longitude job.longitude
  json.city job.city
  json.role job.role
end
