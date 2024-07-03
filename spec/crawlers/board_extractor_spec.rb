require 'rails_helper'

def test_extraction(extractor, input, expected)
    extracted = extractor.extract(input)
    expect(extracted).to eql(expected)
end

RSpec.describe Crawlers::BoardExtractor do
    describe ".extract greenhouse" do
        it "returns the board url from a job url" do
            extractor = Crawlers::BoardExtractor.new
            test_extraction(extractor, 
            'https://boards.greenhouse.io/strava/jobs/5589842', 
            'https://boards.greenhouse.io/strava')
        end
    end
    
    describe ".extract workable" do
        it "returns the board url from a job url" do
            extractor = Crawlers::BoardExtractor.new
            test_extraction(extractor, 
            'https://apply.workable.com/cloudlinux-1/j/3A172A63D5', 
            'https://apply.workable.com/cloudlinux-1')
        end
    end
    
    describe ".extract lever" do
        it "returns the board url from a job url" do
            extractor = Crawlers::BoardExtractor.new
            test_extraction(extractor, 
            'https://jobs.lever.co/streetlightdata/3481a5c1-e59c-4f82-abfb-4b3f9889f87a', 
            'https://jobs.lever.co/streetlightdata')
        end
    end
    
    describe ".extract smartrecruiters" do
        it "returns the board url from a job url" do
            extractor = Crawlers::BoardExtractor.new
            test_extraction(extractor, 
            'https://jobs.smartrecruiters.com/procoretechnologies/743999927460788-hr-strategy-director', 
            'https://careers.smartrecruiters.com/procoretechnologies')
        end
    end
    
    describe ".extract ashby" do
        it "returns the board url from a job url" do
            extractor = Crawlers::BoardExtractor.new
            test_extraction(extractor, 
            'https://jobs.ashbyhq.com/deel/171a6c55-3327-4433-9b50-a561b1ac633c', 
            'https://jobs.ashbyhq.com/deel')
        end
    end
    
    describe ".extract bamboohr" do
        it "returns the board url from a job url" do
            extractor = Crawlers::BoardExtractor.new
            test_extraction(extractor, 
            'https://globalenergymonitor.bamboohr.com/careers/72', 
            'https://globalenergymonitor.bamboohr.com/careers')
        end
    end
    
    describe ".extract recruitee" do
        it "returns the board url from a job url" do
            extractor = Crawlers::BoardExtractor.new
            test_extraction(extractor, 
            'https://petalmd.recruitee.com/o/hr-coordinator', 
            'https://petalmd.recruitee.com')
        end
    end
    
    describe ".extract breezyhr" do
        it "returns the board url from a job url" do
            extractor = Crawlers::BoardExtractor.new
            test_extraction(extractor, 
            'https://clearco.breezy.hr/p/d14b23dc5bab-senior-data-scientist', 
            'https://clearco.breezy.hr')
        end
    end
    
    describe ".extract jazzhr" do
        it "returns the board url from a job url" do
            extractor = Crawlers::BoardExtractor.new
            test_extraction(extractor, 
            'https://cognota.applytojob.com/apply/vCwIGhFGWk/Learning-Operations-Specialist', 
            'https://cognota.applytojob.com/apply')
        end
    end
    
    describe ".extract teamtailor" do
        it "returns the board url from a job url" do
            extractor = Crawlers::BoardExtractor.new
            test_extraction(extractor, 
            'https://snowball.teamtailor.com/jobs/137678-ios-developer', 
            'https://snowball.teamtailor.com/jobs')
        end
    end
    
    describe ".extract workday" do
        it "returns the board url from a job url" do
            extractor = Crawlers::BoardExtractor.new
            test_extraction(extractor, 
            'https://sunrun.wd5.myworkdayjobs.com/en-US/Sunrun_Careers/job/IL-Oak-Brook/Retail-Sales-Associate-I_R27185', 
            'https://sunrun.wd5.myworkdayjobs.com/en-US/Sunrun_Careers')
            test_extraction(extractor, 
            'https://adobe.wd5.myworkdayjobs.com/en-US/external_experienced/job/Bangalore/Solutions-Architect---PreSales_R146911-1', 
            'https://adobe.wd5.myworkdayjobs.com/en-US/external_experienced')
            # different `wdx` version
            test_extraction(extractor, 
            'https://relx.wd3.myworkdayjobs.com/en-US/RiskSolutions/job/Alpharetta-GA/Director--Market-Planning--Fraud---Identity--Fraud-Analytics_R79943', 
            'https://relx.wd3.myworkdayjobs.com/en-US/RiskSolutions')
            # no `en-US`
            test_extraction(extractor, 
            'https://relx.wd3.myworkdayjobs.com/RiskSolutions/job/Alpharetta-GA/Director--Market-Planning--Fraud---Identity--Fraud-Analytics_R79943', 
            'https://relx.wd3.myworkdayjobs.com/RiskSolutions')
        end
    end
    
    describe ".extract jobvite" do
        it "returns the board url from a job url" do
            extractor = Crawlers::BoardExtractor.new
            test_extraction(extractor, 
            'https://jobs.jobvite.com/liquidweb/job/oM6ytfwD',
            'https://jobs.jobvite.com/liquidweb')
        end
    end
    
    describe ".extract rippling" do
        it "returns the board url from a job url" do
            extractor = Crawlers::BoardExtractor.new
            test_extraction(extractor, 
            'https://ats.rippling.com/priorities/jobs/9a465212-cd03-483a-a0af-c97176fe6fac',
            'https://ats.rippling.com/priorities/jobs')
        end
    end
    
    describe ".extract paycom" do
        it "returns the board url from a job url" do
            extractor = Crawlers::BoardExtractor.new
            test_extraction(extractor, 
            'https://www.paycomonline.net/v4/ats/web.php/jobs/ViewJobDetails?job=147865&clientkey=7E727DF780BD14DC46D8F6654DA626DB',
            'https://www.paycomonline.net/v4/ats/web.php/jobs?clientkey=7E727DF780BD14DC46D8F6654DA626DB')
        end
    end
    
    describe ".extract flair hr" do
        it "returns the board url from a job url" do
            extractor = Crawlers::BoardExtractor.new
            test_extraction(extractor, 
            'https://boma.careers.flair.hr/positions/a9GQg0000000dz3MAA',
            'https://boma.careers.flair.hr')
        end
    end
end
