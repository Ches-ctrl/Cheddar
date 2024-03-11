module JoinToJob
  extend ActiveSupport::Concern

  def join_attribute(column_name, value, table, join_table)
    return unless value.present?

    table_name = table.to_s.downcase.to_sym

    attribute_instance = table.find_by(column_name => value) || table.create(column_name => value)

    unless join_table.exists?(job: @job, table_name => attribute_instance)
      join_table.create(job: @job, table_name => attribute_instance)
    end

    return attribute_instance
  end
end
