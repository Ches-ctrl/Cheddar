require 'rails_helper'

def test_extraction(input, expected)
    it "returns the board url from a job url" do
        extractor = Crawlers::BoardExtractor.new
        extracted = extractor.extract(input)
        expect(extracted).to eql(expected)
    end
end

RSpec.describe Crawlers::BoardExtractor do
    describe ".extract greenhouse" do
        test_extraction('https://boards.greenhouse.io/strava/jobs/5589842', 
        'https://boards.greenhouse.io/strava')
    end
    
    describe ".extract workable" do
        test_extraction('https://apply.workable.com/cloudlinux-1/j/3A172A63D5',
        'https://apply.workable.com/cloudlinux-1')
    end
    
    describe ".extract lever" do
        test_extraction('https://jobs.lever.co/streetlightdata/3481a5c1-e59c-4f82-abfb-4b3f9889f87a', 
        'https://jobs.lever.co/streetlightdata')
    end
    
    describe ".extract smartrecruiters" do
        test_extraction('https://jobs.smartrecruiters.com/procoretechnologies/743999927460788-hr-strategy-director', 
        'https://careers.smartrecruiters.com/procoretechnologies')
    end
    
    describe ".extract ashby" do
        test_extraction('https://jobs.ashbyhq.com/deel/171a6c55-3327-4433-9b50-a561b1ac633c', 
        'https://jobs.ashbyhq.com/deel')
    end
    
    describe ".extract bamboohr" do
        test_extraction('https://globalenergymonitor.bamboohr.com/careers/72', 
        'https://globalenergymonitor.bamboohr.com/careers')
    end
    
    describe ".extract recruitee" do
        test_extraction('https://petalmd.recruitee.com/o/hr-coordinator', 
        'https://petalmd.recruitee.com')
    end
    
    describe ".extract breezyhr" do
        test_extraction('https://clearco.breezy.hr/p/d14b23dc5bab-senior-data-scientist', 
        'https://clearco.breezy.hr')
    end
    
    describe ".extract jazzhr" do
        test_extraction('https://cognota.applytojob.com/apply/vCwIGhFGWk/Learning-Operations-Specialist', 
        'https://cognota.applytojob.com/apply')
    end
    
    describe ".extract teamtailor" do
        test_extraction('https://snowball.teamtailor.com/jobs/137678-ios-developer', 
        'https://snowball.teamtailor.com/jobs')
    end
    
    describe ".extract workday" do
        test_extraction('https://sunrun.wd5.myworkdayjobs.com/en-US/Sunrun_Careers/job/IL-Oak-Brook/Retail-Sales-Associate-I_R27185', 
        'https://sunrun.wd5.myworkdayjobs.com/en-US/Sunrun_Careers')
        test_extraction('https://adobe.wd5.myworkdayjobs.com/en-US/external_experienced/job/Bangalore/Solutions-Architect---PreSales_R146911-1', 
        'https://adobe.wd5.myworkdayjobs.com/en-US/external_experienced')
        # different `wdx` version
        test_extraction('https://relx.wd3.myworkdayjobs.com/en-US/RiskSolutions/job/Alpharetta-GA/Director--Market-Planning--Fraud---Identity--Fraud-Analytics_R79943', 
        'https://relx.wd3.myworkdayjobs.com/en-US/RiskSolutions')
        # no `en-US`
        test_extraction('https://relx.wd3.myworkdayjobs.com/RiskSolutions/job/Alpharetta-GA/Director--Market-Planning--Fraud---Identity--Fraud-Analytics_R79943', 
        'https://relx.wd3.myworkdayjobs.com/RiskSolutions')
    end
    
    describe ".extract jobvite" do
        test_extraction('https://jobs.jobvite.com/liquidweb/job/oM6ytfwD',
        'https://jobs.jobvite.com/liquidweb')
    end
    
    describe ".extract rippling" do
        test_extraction('https://ats.rippling.com/priorities/jobs/9a465212-cd03-483a-a0af-c97176fe6fac',
        'https://ats.rippling.com/priorities/jobs')
    end
    
    describe ".extract paycom" do
        test_extraction('https://www.paycomonline.net/v4/ats/web.php/jobs/ViewJobDetails?job=147865&clientkey=7E727DF780BD14DC46D8F6654DA626DB',
        'https://www.paycomonline.net/v4/ats/web.php/jobs?clientkey=7E727DF780BD14DC46D8F6654DA626DB')
    end
    
    describe ".extract flair hr" do
        test_extraction('https://boma.careers.flair.hr/positions/a9GQg0000000dz3MAA',
        'https://boma.careers.flair.hr')
    end
end
