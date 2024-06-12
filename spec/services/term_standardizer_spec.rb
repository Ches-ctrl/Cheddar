require 'rails_helper'
require Rails.root.join('spec', 'support', 'spec_constants.rb')

RSpec.describe Standardizer::TermStandardizer do
  describe '#standardize_term' do
    before do
      @standardizer = Standardizer::TermStandardizer.new
    end

    it 'returns nil when a term does not exist' do
      first_term = @standardizer.standardize_term(nil, :employment_type)
      second_term = @standardizer.standardize_term(nil, :seniority)

      expect(first_term).to be_nil
      expect(second_term).to be_nil
    end

    it 'returns a nonstandard term unchanged if no suitable replacement is found' do
      first_term = @standardizer.standardize_term('foo_bar', :employment_type)
      second_term = @standardizer.standardize_term('gobbledy-gook', :seniority)

      expect(first_term).to eq('foo_bar')
      expect(second_term).to eq('gobbledy-gook')
    end

    context 'With nonstandard seniority descriptors:' do
      terms = {
        'intern' => 'Internship',
        'midlevel' => 'Mid-Level',
        'Experienced' => 'Senior',
        'Manager/Supervisor' => 'Senior',
        'Team_lead' => 'Senior',
        'International Manager' => 'Senior'
      }

      terms.each do |term, standard_term|
        it "returns #{standard_term} in place of #{term}" do
          result = @standardizer.standardize_term(term, :seniority)
          expect(result).to eq(standard_term)
        end
      end
    end

    context 'With nonstandard employment_types:' do
      terms = {
        'fulltime' => 'Full-time',
        'Permanent full-time employee' => 'Full-time',
        'Global Core Team Contract' => 'Contract',
        'Fixed Term' => 'Contract',
        'Fixed-term fulltime employee' => 'Contract',
        'Part-time contract' => 'Contract'
      }

      terms.each do |term, standard_term|
        it "returns #{standard_term} in place of #{term}" do
          result = @standardizer.standardize_term(term, :employment_type)
          expect(result).to eq(standard_term)
        end
      end
    end
  end
  describe '#standardize' do
    it 'replaces a nonstandard seniority descriptor with its standard equivalent' do
      job = create(:job, seniority: 'junior associate')
      Standardizer::TermStandardizer.new(job).standardize
      expect(job.seniority).to eq('Junior')
    end
    it 'replaces a nonstandard employment_type with its standard equivalent' do
      job = create(:job, employment_type: 'Global Core Team Contract')
      Standardizer::TermStandardizer.new(job).standardize
      expect(job.employment_type).to eq('Contract')
    end
  end
end
