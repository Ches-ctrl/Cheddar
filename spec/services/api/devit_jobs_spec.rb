RSpec.describe Api::DevitJobs do
  describe "DevItJobs Integration" do
    pending "add some examples (or delete) #{__FILE__}"
  end
  # let!(:kliq){ create(:company, name: 'Kliq Inc') }

  # let(:xml_response) do
  #   builder = Nokogiri::XML::Builder.new do |xml|
  #     xml.jobs {
  #       xml.job {
  #         xml.id_ "10"
  #         xml.title "Front-End Developer"
  #         xml.apply_url "https://frontend_application_url.com"
  #         xml.country "Spain"
  #         xml.salary "$50000"
  #         xml.company "#{kliq.name}"
  #         xml.description "Front end developer position"
  #         xml.pubdate "#{Date.current - 2.days}"
  #       }
  #       xml.job {
  #         xml.id_ "11"
  #         xml.title "Full-Stack Developer"
  #         xml.apply_url "https://fullstack_application_url.com"
  #         xml.country "Canada"
  #         xml.salary "$90000"
  #         xml.company "Welp Inc"
  #         xml.description "Full-Stack developer position"
  #         xml.pubdate "#{Date.current}"
  #       }
  #     }
  #   end
  #   Nokogiri::XML(builder.to_xml)
  # end

  # describe '#scrape page' do
  #   subject { described_class.new }
  #   it 'only creates companies that does not exist' do
  #     allow(subject).to receive(:page_doc).with('https://devitjobs.uk/job_feed.xml').and_return(xml_response)


  #     expect { subject.scrape_page }.to change(Company, :count).by(1)
  #   end

  #   context 'create jobs' do
  #     before { create(:job, posting_url: 'https://frontend_application_url.com') }

  #     it 'only creates job that does not exist' do
  #       allow(subject).to receive(:page_doc).with('https://devitjobs.uk/job_feed.xml').and_return(xml_response)

  #       expect { subject.scrape_page }.to change(Job, :count).by(1)
  #     end
  #   end
  # end
end
