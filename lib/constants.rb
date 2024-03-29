module Constants
  ATS_SYSTEM_PARSER = {
    /greenhouse/ => 'Greenhouse',
    /gh_jid/ => 'Greenhouse',
    /workable/ => 'Workable',
    /lever/ => 'Lever',
    # /smartrecruiters/ => 'smartrecruiters',
    /ashbyhq/ => 'Ashbyhq',
    /pinpointhq/ => 'Pinpointhq',
    /bamboohr/ => 'Bamboohr',
    /recruitee/ => 'Recruitee',
    /manatal/ => 'Manatal',
    /careers-page/ => 'Manatal'
    # /totaljobs/ => 'TotalJobs',
    # /simplyhired/ => 'Simplyhired',
    # /workday/ => 'Workday',
    # /tal.net/ => 'Tal.net',
    # /indeed/ => 'Indeed',
    # /freshteam/ => 'Freshteam',
    # /phenom/ => 'Phenom',
    # /jobvite/ => 'Jobvite',
    # /icims/ => 'Icims',
    # Add other supported ATS systems here
  }

  JOB_LOCATION_KEYWORDS = [
    /london/,
    /england/,
    /united kingdom/,
    /britain/,
    /\buk\b/,
    /\bemea\b/
  ]

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
    /data engineer/,
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
  ]
end
