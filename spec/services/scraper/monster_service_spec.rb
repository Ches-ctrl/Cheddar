RSpec.describe Scraper::MonsterService do
  let!(:company1) { create(:company) }
  let(:job1) do
    {
      job_title: 'Rails Engineer',
      company_id: company1.id,
      job_description: 'Ruby on Rails engineer with 3 years experience',
      job_posting_url: 'https://dummy_job_url.com',
      location: 'Atlanta, Gerogia',
      date_created: DateTime.yesterday
    }
  end
  xit 'creates companies that do not exists already' do
    monster_service = described_class.new

    monster_service.instance_variable_set(:@jobs, [job1])
    expect(monster_service.scrape_page).to eq []
  end
end
