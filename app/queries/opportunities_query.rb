# frozen_string_literal: true

class OpportunitiesQuery < ApplicationQuery
  def initialize(relation = Job.all)
    @relation = relation
  end

  def call
    @relation = @relation.eager_load(*associations)
    Flipper.enabled?(:london_junior_dev_roles) ? london_junior_dev_roles(@relation) : @relation
  end

  private

  def associations
    %i[requirement company locations countries roles applicant_tracking_system]
      .push({ locations: :country })
  end

  def london_junior_dev_roles(relation)
    query = { seniority: ["Entry-Level", "Junior"], locations: { city: ["London"] }, employment_type: ["Full-Time"] }
    relation.where(query)
  end
end
