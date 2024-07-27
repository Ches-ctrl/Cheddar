# frozen_string_literal: true

class ApplicationQuestion
  # == PORO - Accessors =====================================================
  attr_accessor :section, :attribute, :label, :fields, :required, :description

  # == Attributes ===========================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Constants ============================================================
  # == Extensions ===========================================================
  # == Initialize ============================================================
  def initialize(questions_params)
    questions_params.map do |key, value|
      public_send("#{key}=", value)
    end
  end

  # == Instance Methods =====================================================
  # == Relationships ========================================================
  # == Scopes ===============================================================
  # == Validations ==========================================================

  def boolean? = type.eql?("boolean")
  def checkbox? = type.eql?("checkbox")
  def cover_letter? = attribute.include?("cover_letter")
  def input? = type.eql?("input") || type.eql?("education_input")
  def linkedin_related? = attribute.include?('linkedin')
  def multi_select? = type.eql?("multi_select")
  def radiogroup? = type.eql?("radiogroup")
  def resume? = attribute.eql?("resume")
  def select? = type.eql?("select") || type.eql?("education_select")
  def textarea? = type.eql?("textarea")
  def upload? = type.eql?("upload")

  def answered_value(job_application)
    return job_application.resume.blob.url if resume? && job_application.resume.attached?
    return job_application.cover_letter.blob.url if cover_letter? && job_application.cover_letter.attached?

    # return multi_answered_value(job_application) if multi_select?

    job_application.additional_info[attribute]
  end

  # def multi_answered_value(job_application)
  #   job_application.additional_info.select do |k, values|
  #     byebug
  #   end
  # end

  def boolean_options
    [['Yes', 'true'], ['No', 'false']]
  end

  def field = fields.first

  def locator = field['selector'] || "##{field['id']}"

  def multi_checkbox?
    type.eql?("checkbox") && (options&.count&.> 1)
  end

  def option_text_value(value)
    return value if options.none?

    options.to_h.invert[value]
  end

  def options
    field['options'].map { |option| [option['label'], option['id']] }
  end

  def payload(job_application)
    { locator:, interaction: type, value: answered_value(job_application) }
  end

  def selector = field['selector'] || field['id']

  def type = field['type']

  def valid?
    if checkbox? || radiogroup?
      options&.count&.positive?
    else
      true
    end
  end
end
