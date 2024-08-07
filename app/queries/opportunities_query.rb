# frozen_string_literal: true

class OpportunitiesQuery < ApplicationQuery
  def initialize(relation = Job.all)
    @relation = relation
  end

  def call
    @relation = @relation.eager_load(*associations)
    @relation = london_junior_dev_roles if Flipper.enabled?(:london_junior_dev_roles)
    @relation
  end

  private

  def associations
    %i[requirement company locations roles applicant_tracking_system]
  end

  def london_junior_dev_roles
    query = { seniority: ["Entry-Level", "Junior"], locations: { city: ["London"] }, employment_type: ["Full-Time"] }
    @relation.where(query)
  end
end
