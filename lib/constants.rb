# frozen_string_literal: true

module Constants
  # TODO: refactor all these constants into sub-modules? Seems like rails convention may be to have this in a yaml file so TBD structure

  module Files
    FILES = [
      'job_posting_urls.csv',
      'grnse_job_posting_urls.csv',
      '80k_job_posting_urls.csv',
      'BN_job_posting_urls.csv',
      'CO_job_posting_urls.csv',
      'GH_job_posting_urls.csv',
      'LU_job_posting_urls.csv',
      'PA1_job_posting_urls.csv',
      'PA2_job_posting_urls.csv',
      'UM_job_posting_urls.csv'
      # 'company_urls.csv'
    ].freeze
  end

  module DateConversion
    CONVERT_TO_DAYS = {
      'today' => 0,
      '3-days' => 3,
      'week' => 7,
      'month' => 30,
      'any-time' => 99_999
    }.freeze
  end

  module CategorySidebar
    SENIORITIES = [
      'Spring Week',
      'Internship',
      'Entry-Level',
      'Junior',
      'Mid-Level',
      'Senior',
      'Director',
      'VP',
      'SVP / Partner'
    ].freeze

    ROLES = {
      'front_end' => 'Front End',
      'back_end' => 'Back End',
      'full_stack' => 'Full Stack',
      'dev_ops' => 'Dev Ops',
      'qa_test_engineer' => 'QA/Test Engineer',
      'mobile' => 'Mobile',
      'data_engineer' => 'Data Engineer'
    }.freeze

    EMPLOYMENT_TYPES = [
      'Full-time',
      'Permanent',
      'Contract',
      'Part-time',
      'Internship'
    ].freeze

    CONVERT_TO_DAYS = {
      'Any time' => 99_999,
      'Within a month' => 30,
      'Within a week' => 7,
      'Last 3 days' => 3,
      'Today' => 0
    }.freeze

    # TODO: Decide on what business type/size cuts we want
    BUSINESS_TYPES = [
      'Startup',
      'Scale-up',
      'Boutique',
      'SME',
      'Corporate',
      'Non-profit',
      'Charity',
      'Public Sector',
      'NGO',
      'FTSE100',
      'FTSE250',
      'Fortune 500',
      'Unicorn',
      'Decacorn',
      'Family Business',
      'Academic'
    ].freeze

    # TODO: Decide if we want to include this
    HORIZONTALS = [
      'Sustainability',
      'Finance',
      'HR',
      'Legal',
      'Marketing',
      'Operations',
      'Product',
      'Sales',
      'Tech',
      'Other'
    ].freeze
  end

  SENIORITY_TITLES = {
    /staff/i => 'Senior',
    /principal/i => 'Senior',
    /\blead\b/i => 'Senior',
    /senior/i => 'Senior',
    /\biii\b/i => 'Mid-Level',
    /\bii\b/i => 'Mid-Level',
    /mid-?level/i => 'Mid-Level',
    /mid-?weight/i => 'Mid-Level',
    /\bmid[\b_-]/i => 'Mid-Level',
    /junior/i => 'Junior',
    /early.?career/i => 'Junior',
    /\bi\b/i => 'Junior',
    /associate/i => 'Junior',
    /[gG]raduate/i => 'Entry-Level',
    /[gG]rad/i => 'Entry-Level',
    /[iI]ntern/i => 'Internship'
  }.freeze

  SENIORITY_DESCRIPTORS = {
    /track record of/ => 'Junior',
    /(commercial|professional|production|significant) experience(?!\s*(?:.{0,40}not\s+(?:essential|required)))/ => 'Mid-Level',
    /proficien(cy|t) (in|with) (?!\s*(?:.{0,40}not\s+(?:essential|required)))/ => 'Mid-Level',
    /deep.{0,28} (knowledge|expertise)(?!\s*(?:.{0,40}not\s+(?:essential|required)))/ => 'Mid-Level',
    /experience (in|with).{0,50} (commercial|professional)/ => 'Mid-Level',
    /experience.{3,28} non-internship/ => 'Mid-Level',
    /(mid-level|intermediate).{0,28} (developer|engineer)/ => 'Mid-Level',
    /extensive experience(?!\s*(?:.{0,40}not\s+(?:essential|required)))/ => 'Senior',
    /(seasoned|senior).{0,28} (developer|engineer)/ => 'Senior',
    /expert\b/ => 'Senior'
  }.freeze

  JOB_LOCATION_KEYWORDS = [
    /remote/i,
    /london/i,
    /england/i,
    /scotland/i,
    /wales/i,
    /northern ireland/i,
    /united kingdom/i,
    /britain/i,
    /\buk\b/i,
    /\bgb\b/i,
    /\bemea\b/i
  ].freeze

  JOB_LOCATION_FILTER_WORDS = [
    /(full.)?remote/i,
    /hybrid/i,
    /emea/i,
    /location/i,
    %r{\bn/?a\b}i,
    %r{/}
  ].freeze

  JOB_TITLE_KEYWORDS = [
    /front.?end/i,
    /back.?end/i,
    /full.?stack/i,
    /developer/i,
    /programmer/i,
    /software/i,
    /\bweb\b/i,
    /technical lead/i,
    /technical support/i,
    /technical artist/i,
    /development engineer/i,
    /product (?:engineer|designer)/i,
    /deployed.{1,28}engineer/i,
    /data.?engineer/i,
    /research engineer/i,
    /prompt engineer/i,
    /mobile (?:engineer|developer)/i,
    /infrastructure (?:engineer|architect)/i,
    /platform (?:engineer|architect)/i,
    /security (?:engineer|architect)/i,
    /cloud (?:engineer|architect)/i,
    /network (?:engineer|architect)/i,
    /reliability engineer/i,
    /\bsre engineer/i,
    /support engineer/i,
    /escalation engineer/i,
    /test automation engineer/i,
    /analytics engineer/i,
    /gameplay/i,
    /\bui\b/i,
    /\bux\b/i,
    /\bqa\b/i,
    /dev-?ops/i,
    /\bios\b/i,
    /android/i,
    /data scientist/i,
    /dataops/i,
    /\bml\b/i,
    /\bai\b/i,
    /machine learning/i,
    /blockchain/i,
    /game designer/i,
    /low.?latency/i,
    /run.?time/i,
    /cybersecurity/i,
    /threat detection/i,
    /malware/i,
    /technical designer/i,
    /\bseo\b/i,
    /ruby/i,
    /ruby on rails/i,
    /python/i,
    /django/i,
    /\.net\b/i,
    /\bc#/i,
    /\bc\+\+/i,
    /java/i,
    /springboot/i,
    /kafka/i,
    /distributed systems/i,
    /server/i,
    /golang/i,
    /javascript/i,
    /\bjs\b/i,
    /nodejs/i,
    /\breact\b/i,
    /jenkins/i,
    /terraform\b/i,
    %r{\bci/cd\b},
    /database/i,
    /\bsql\b/i,
    /workflow automation/i,
    /\bapi\b/i,
    /data platform/i,
    /cloud platform/i,
    /cloud ops/i,
    /kubernetes/i,
    /\baws\b/i,
    /google cloud/i,
    /\bgcp\b/i,
    /linux/i,
    /unix/i,
    /\btcp\b/i
  ].freeze

  CURRENCY_CONVERTER = {
    '$' => ['$', ' USD'],
    '£' => ['£', ' GBP'],
    '€' => ['€', ' EUR'],
    'usd' => ['$', ' USD'],
    'can' => ['$', ' CAD'],
    'cdn' => ['$', ' CAD'],
    'cad' => ['$', ' CAD'],
    'aud' => ['$', ' AUD'],
    'gbp' => ['£', ' GBP'],
    'eur' => ['€', ' EUR']
  }.freeze

  HIRING_MODES = [
    'Milkround',
    'Structured',
    'Ad-hoc'
  ].freeze

  CAREERS_STUBS = [
    "jobs",
    "careers",
    "get-involved",
    "positions",
    "job-openings",
    "current-job-openings",
    "careers-list",
    "open-careers",
    "open-positions",
    "opportunities",
    "open-roles",
    "current-openings",
    "hiring",
    "apply"
  ].freeze
end
