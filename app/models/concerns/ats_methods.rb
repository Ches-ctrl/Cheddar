module AtsMethods
  def base_url_api
    this_ats.base_url_api
  end

  def this_ats
    match = to_s.match(/Ats::(\w+)(?=\W)/)
    ApplicantTrackingSystem.find_by(name: match[1])
  end
end
