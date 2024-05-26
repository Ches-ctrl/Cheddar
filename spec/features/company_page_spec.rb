require 'rails_helper'

RSpec.feature "CompanyPage", type: :feature, company_page: true do
  let(:company) { create(:company, url_website: "http://example.com", url_linkedin: "http://linkedin.com/in/example", url_careers: nil, url_ats_api: "http://ats.example.com") }

  scenario "User visits the company show page" do
    visit company_path(company)

    expect(page).to have_link("Website", href: "http://example.com")
    expect(page).to have_link("LinkedIn", href: "http://linkedin.com/in/example")
    expect(page).not_to have_link("Careers Site")
    expect(page).to have_link("ATS Site", href: "http://ats.example.com")
  end
end
