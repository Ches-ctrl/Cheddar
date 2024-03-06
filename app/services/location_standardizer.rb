class LocationStandardizer
  def initialize(job)
    @job = job
  end

  def standardize
    return unless @job.location

    location = @job.location
    hybrid = location.downcase.include?('hybrid') || @job.job_description.downcase.include?('hybrid')
    remote = location.downcase.match?(/(?<!\bor\s)remote/)

    location_elements = location.split(',').map { |element| element.gsub(/[-;(\/].*/, '').gsub(/([Rr]emote|[Hh]ybrid)\s*[,;:-]?\s*/, '').strip }
    @job.location = location_elements.reject(&:empty?).join(', ')

    @job.hybrid = hybrid
    @job.remote_only = remote && !hybrid

    @job.location = @job.country if @job.location.empty?
    @job.location += " (Remote)" if @job.remote_only
  end
end
