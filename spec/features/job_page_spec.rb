require 'rails_helper'

RSpec.feature "JobPage", type: :feature, job_page: true do
  let(:company) { create(:company) }
  let(:job) { create(:job, company: company) }

  scenario "User visits the job show page" do
    visit job_path(job)

    expect(page).to have_content(job.title)
    expect(page).to have_content(company.name)
  end
end
