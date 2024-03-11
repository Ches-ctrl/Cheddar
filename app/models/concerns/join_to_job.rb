module JoinToJob
  extend ActiveSupport::Concern

  def join_attribute(values, table, join_table)
    primary_key, primary_value = values.first
    return if primary_value.nil?

    table_name = table.to_s.downcase.to_sym

    attribute_instance = table.find_by(primary_key => primary_value) || table.create!(values)

    unless join_table.exists?(job: @job, table_name => attribute_instance)
      join_table.create(job: @job, table_name => attribute_instance)
    end

    return attribute_instance
  end
end
