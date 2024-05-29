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
    /remote/,
    /london/,
    /england/,
    /united kingdom/,
    /britain/,
    /\buk\b/,
    /\bemea\b/
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
    /front.?end/,
    /back.?end/,
    /full.?stack/,
    /developer/,
    /programmer/,
    /software/,
    /\bweb\b/,
    /technical lead/,
    /technical support/,
    /technical artist/,
    /development engineer/,
    /product (?:engineer|designer)/,
    /deployed.{1,28}engineer/,
    /data.?engineer/,
    /research engineer/,
    /prompt engineer/,
    /mobile (?:engineer|developer)/,
    /infrastructure (?:engineer|architect)/,
    /platform (?:engineer|architect)/,
    /security (?:engineer|architect)/,
    /cloud (?:engineer|architect)/,
    /network (?:engineer|architect)/,
    /reliability engineer/,
    /\bsre engineer/,
    /support engineer/,
    /escalation engineer/,
    /test automation engineer/,
    /analytics engineer/,
    /gameplay/,
    /\bui\b/,
    /\bux\b/,
    /\bqa\b/,
    /dev-?ops/,
    /\bios\b/,
    /android/,
    /data scientist/,
    /dataops/,
    /\bml\b/,
    /\bai\b/,
    /machine learning/,
    /blockchain/,
    /game designer/,
    /low.?latency/,
    /run.?time/,
    /cybersecurity/,
    /threat detection/,
    /malware/,
    /technical designer/,
    /\bseo\b/,
    /ruby/,
    /ruby on rails/,
    /python/,
    /django/,
    /\.net\b/,
    /\bc#/,
    /\bc\+\+/,
    /java/,
    /springboot/,
    /kafka/,
    /distributed systems/,
    /server/,
    /golang/,
    /javascript/,
    /\bjs\b/,
    /nodejs/,
    /\breact\b/,
    /jenkins/,
    /terraform\b/,
    %r{\bci/cd\b},
    /database/,
    /\bsql\b/,
    /workflow automation/,
    /\bapi\b/,
    /data platform/,
    /cloud platform/,
    /cloud ops/,
    /kubernetes/,
    /\baws\b/,
    /google cloud/,
    /\bgcp\b/,
    /linux/,
    /unix/,
    /\btcp\b/
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
end
