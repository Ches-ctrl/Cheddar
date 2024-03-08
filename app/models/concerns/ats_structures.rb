# -----------------
# Greenhouse ATS
# -----------------

# Docs:
# https://developers.greenhouse.io/job-board.html

# API Capabilities:
# All ATS Jobs - ❌
# Company - ✅
# All Jobs - ✅
# Job Description - ✅
# Job Form - 🟧

# Main URLs:
# https://boards.greenhouse.io/#{company_name}/jobs
# https://boards.greenhouse.io/#{company_name}/jobs/#{job_id}

# Alternative URLs:
# https://boards.greenhouse.io/embed/job_app?for=#{company_name}&token=#{job_id}
# https://boards.#{region_code}.greenhouse.io/embed/job_app?for=#{company_name}&token=#{job_id}

# API URLs:
# https://boards-api.greenhouse.io/v1/boards/#{company_name}
# https://boards-api.greenhouse.io/v1/boards/#{company_name}/jobs
# https://boards-api.greenhouse.io/v1/boards/#{company_name}/jobs/#{job_id}

# Redirect (Embed) API URLs:
# https://boards-api.greenhouse.io/#{company_name}
# https://boards-api.greenhouse.io/#{company_name}/jobs
# https://boards-api.greenhouse.io/#{company_name}/jobs/#{job_id}

# -----------------
# Workable ATS
# -----------------

# API Capabilities:
# All ATS Jobs - ✅
# Company - ✅
# All Jobs - ❌ (Yes, but requires scrape)
# Job Description - ✅
# Job Form - ❌

# Docs:
# https://workable.readme.io/reference/generate-an-access-token

# All ATS Jobs:
# https://jobs.workable.com/
# https://www.workable.com/boards/workable.xml

# Main URLs:
# https://apply.workable.com/#{company_name}
# https://apply.workable.com/#{company_name}/j/{job_id}
# https://apply.workable.com/#{company_name}/j/{job_id}/apply/

# API URLs:
# https://apply.workable.com/api/v1/accounts/#{company_id}
# https://apply.workable.com/api/v1/accounts/#{company_id}/jobs/#{job_id}
# https://apply.workable.com/api/v1/accounts/#{company_id}/locations # sometimes not present
# https://apply.workable.com/api/v1/accounts/#{company_id}/departments # sometimes not present

# Widget (Embed) API URLs:
# https://apply.workable.com/api/v1/widget/accounts/#{company_id}

# -----------------
# Lever ATS
# -----------------

# API Capabilities:
# All ATS Jobs - ❌
# Company - ✅
# All Jobs - ✅
# Job Description - ✅
# Job Form - ❌

# Docs:
# https://hire.lever.co/developer/documentation

# Main URLs:
# https://jobs.lever.co/#{company_name}
# https://jobs.lever.co/#{company_name}/#{job_id}
# https://jobs.lever.co/#{company_name}/#{job_id}/apply

# API URLs:
# https://api.lever.co/v0/postings/#{company_id} # list of links (not JSON)
# https://api.lever.co/v0/postings/#{company_id}?mode=json # list of links (JSON) - HTML & iframe possible
# https://api.lever.co/v0/postings/#{company_id}/#{job_id}

# API URLs (Embed):
# https://api.lever.co/#{company_id}

# -----------------
# SmartRecruiters ATS
# -----------------

# API Capabilities:
# All ATS Jobs - ✅
# Company - ❌
# All Jobs - ✅
# Job Description - ✅
# Job Form - ❌

# Docs:
# https://developers.smartrecruiters.com/docs/the-smartrecruiters-platform

# All ATS Jobs:
# https://jobs.smartrecruiters.com/

# Main URLs:
# https://jobs.smartrecruiters.com/#{company_name}/#{job_id} # jobs. redirects to careers.

# API URLs:
# https://api.smartrecruiters.com/v1/companies/#{company_id}/postings
# https://api.smartrecruiters.com/v1/companies/#{company_id}/postings/#{job_id}

# -----------------
# Ashby ATS
# -----------------

# API Capabilities:
# All ATS Jobs - ✅
# Company - ✅
# All Jobs - ✅
# Job Description - ✅ (main page)
# Job Form - ❌

# Docs:
# https://developers.ashbyhq.com/docs/public-job-posting-api

# Main URLs:
# https://jobs.ashbyhq.com/#{company_name}/
# https://jobs.ashbyhq.com/#{company_name}/#{job_id}

# API URLs:
# https://api.ashbyhq.com/posting-api/job-board/{JOB_BOARD_NAME}?includeCompensation=true
# Individual listings - N/A


# -----------------
# PinpointHQ ATS
# -----------------

# API Capabilities:
# All ATS Jobs - ❌
# Company - ❌
# All Jobs - ✅
# Job Description - ✅
# Job Form - ❌

# Docs:
# https://developers.pinpointhq.com/docs/introduction

# Main URLs:
# https://{company_name}.pinpointhq.com/

# API URLs:
# https://{company_name}.pinpointhq.com/postings.json


# -----------------
# BambooHR ATS
# -----------------

# API Capabilities:
# All ATS Jobs - ❌
# Company - ❌
# All Jobs - 🟧
# Job Description - ✅
# Job Form - ❌

# Docs:
#

# Main URLs:
# https://${company}.bamboohr.com/careers
# https://${company}.bamboohr.com/careers/${id}

# API URLs:
# https://${company}.bamboohr.com/careers/list


# -----------------
# Recruitee ATS
# -----------------

# API Capabilities:
# All ATS Jobs - ❌
# Company - ❌
# All Jobs - 🟧
# Job Description - ✅
# Job Form - ❌

# Docs:
#

# Main URLs:
#

# API URLs:
#

# -----------------
# Manatal ATS
# -----------------

# API Capabilities:
# All ATS Jobs - ❌
# Company - ❌
# All Jobs - ✅
# Job Description - ✅
# Job Form - ✅

# Docs:
#

# Main URLs:
#

# API URLs:
#


# -----------------
# Workday ATS
# -----------------

# NB. Complex API, not public

# API Capabilities: (requires scrape)
# All ATS Jobs - ❌
# Company - ❌
# All Jobs - ❌
# Job Description - ❌
# Job Form - ❌

# Scrape Capabilities:
# All ATS Jobs - ❌
# Company - ✅
# All Jobs - ✅
# Job Description - ✅
# Job Form - ✅

# Docs:
# https://community.workday.com/sites/default/files/file-hosting/restapi/index.html#recruiting/v3/jobPostings

# Main URLs:
# https://#{company_name}.wd1.myworkdayjobs.com/en-US/GTI
# https://#{company_name}.wd1.myworkdayjobs.com/en-US/GTI/job/London-United-Kingdom/{job_id}
# https://#{company_name}.wd1.myworkdayjobs.com/en-US/GTI/job/London%2C-United-Kingdom/{job_id}/apply/applyManually

# Potential API Urls (not public)
# https://impl.workday.com/#{company}/d/home.html
# https://workdaysuv.com/api/recruiting/v3/#{company}/jobPostings
# https://wd2-impl-services1.workday.com/ccx/api/v1/#{company}/jobpostings

# -----------------
# Tal.net ATS
# -----------------

# API Capabilities: ?
# All ATS Jobs - ❌
# Company - ❌
# All Jobs - ❌
# Job Description - ❌
# Job Form - ❌

# Main URLS:
# "https://#{agency_name}.tal.net/candidate"


# -----------------
# Freshteam ATS
# -----------------

# API Capabilities: (requires scrape)
# All ATS Jobs - ❌
# Company - ❌
# All Jobs - ❌
# Job Description - ❌
# Job Form - ❌

# https://#{company}.freshteam.com/api/job_postings # requires authentication


# -----------------
# Phenom ATS
# -----------------

# API Capabilities: (requires scrape)
# All ATS Jobs - ❌
# Company - ❌
# All Jobs - ❌
# Job Description - ❌
# Job Form - ❌

# https://api.phenom.com/
# https://api.phenompeople.com/


# -----------------
# Job Board Portals - Docs
# -----------------

# LinkedIn - https://learn.microsoft.com/en-us/linkedin/talent/job-postings/api/overview - Private
# Glassdoor - https://www.glassdoor.co.uk/developer/index.htm - Private
# Indeed - https://docs.indeed.com/dev/docs/authentication-landing-page - Private
# ZipRecruiter - https://www.ziprecruiter.com/partner/documentation/#ziprecruiter-partner-platform - Private
# Bamboo HR - https://documentation.bamboohr.com/docs/getting-started - Private
# Simplyhired - N/A (The Stepstone Group)
# Totaljobs - N/A


# -----------------
# Job Search Portals
# -----------------

# Simplyhired - N/A (The Stepstone Group)
# Totaljobs - N/A
# https://www.ziprecruiter.co.uk/


# -----------------
# Misc Notes (Greenhouse)
# -----------------

# Greenhouse Main URLs:
# https://boards.greenhouse.io/#{company_name}/jobs/#{job_id}
# https://boards.greenhouse.io/embed/job_app?for=#{company_name}&token=#{job_id}
# https://boards.#{region_code}.greenhouse.io/embed/job_app?for=#{company_name}&token=#{job_id}

# Greenhouse API URLs:
# https://boards-api.greenhouse.io/v1/boards/#{company_name} # Sometimes redirects
# https://boards-api.greenhouse.io/#{company_name}
# https://boards-api.greenhouse.io/#{company_name}/jobs
# https://boards-api.greenhouse.io/#{company_name}/jobs/#{job_id}

# Regular Expression Matching:
#   url_pattern_1 = %r{https://boards\.greenhouse\.io/([^/]+)/jobs/(\d+)}
#   url_pattern_2 = %r{https://boards\.greenhouse\.io/embed/job_app\?for=([^&]+)&token=(\w+)}
#   url_pattern_3 = %r{https://boards\.([^\.]+)\.greenhouse\.io/embed/job_app\?for=([^&]+)&token=(\w+)}

# Types of hosting a Jobs Board with Greenhouse:
# - Host a job board with Greenhouse
# - Embed a Greenhouse job board in your website
# - Embed an API-driven job board in your website and host job applications with Greenhouse
# - Embed an API-driven job board and application form in your website
# - Create a fully API-driven job board


# -----------------
# Other ATS Structures
# -----------------

# https://baringa-stg.csod.com/client/baringa/default.aspx
# https://recruit.zoho.com/recruit/v2/settings/roles
# https://careers.pageuppeople.com/754/ci/en/job/496892/store-manager
# https://krb-sjobs.brassring.com/tgnewui/search/home/home?partnerid=26059&siteid=5016#home
# https://wmp.referrals.selectminds.com/
# https://career5.successfactors.eu/careers?company=nttdatade&site=&career_ns=job_application&login_ns=register&career_job_req_id=18948
# https://yays.recruitee.com/
