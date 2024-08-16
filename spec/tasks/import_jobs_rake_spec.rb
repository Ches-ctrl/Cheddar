require 'rails_helper'
require 'rake'

RSpec.describe 'importer:xml:import_jobs', type: :task do
  before :all do
    Rake.application.rake_require 'tasks/import_jobs'
    Rake::Task.define_task(:environment)
  end

  it 'executes the import_jobs task successfully' do
    expect(Importer::Xml::WorkableParserJob).to receive(:perform_now)
    Rake::Task['importer:xml:import_jobs'].invoke
  end
end