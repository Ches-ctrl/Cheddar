# frozen_string_literal: true

class ApplicationQuery
  def self.call(...)
    new(...).call
  end

  def default_order = asc_order

  def asc_order
    :created_at
  end

  def desc_order
    { created_at: :desc }
  end

  def updated_at_asc_order
    :updated_at
  end

  def updated_at_desc_order
    { updated_at: :desc }
  end
end
