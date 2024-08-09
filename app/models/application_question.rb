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

  # nb: attribute can be nil, so safe navigation operator is necessary with #include?

  def agreement_checkbox? = type.eql?("agreement_checkbox")
  def attachment? = cover_letter? || photo? || resume?
  def boolean? = type.eql?("boolean")
  def checkbox? = type.eql?("checkbox")
  def cover_letter? = attribute&.include?("cover_letter")
  def date_picker? = type.eql?("date_picker")
  def input? = type.eql?("input") || type.eql?("education_input")
  def linkedin_related? = attribute&.include?('linkedin')
  def multi_select? = type.eql?("multi_select")
  def photo? = attribute.eql?("photo")
  def radiogroup? = type.eql?("radiogroup")
  def resume? = attribute.eql?("resume")
  def select? = type.eql?("select") || type.eql?("education_select")
  def textarea? = type.eql?("textarea")
  def upload? = type.eql?("upload")

  def boolean_options
    [['Yes', 'true'], ['No', 'false']]
  end

  def converted_type
    return 'input' if type.eql?('textarea') || type.eql?('date_picker')
    return 'boolean' if type.eql?('agreement_checkbox')

    type
  end

  def cover_letter_text_available?
    attribute.eql?('cover_letter') && fields.count > 1 && fields.any? { |field| field['name'].eql?('cover_letter_text') }
  end

  def field
    return fields.find { |field| field['name'].eql?('cover_letter_text') } if cover_letter_text_available?

    fields.first
  end

  def answered_value(job_application)
    return job_application.resume.blob.url if resume? && job_application.resume.attached?
    return job_application.cover_letter.blob.url if cover_letter? && job_application.cover_letter.attached?

    job_application.additional_info[attribute]
  end

  def locator = field['selector'] || field['name']

  def multi_checkbox?
    type.eql?("checkbox") && (options&.count&.> 1)
  end

  def option_text_values(values)
    return values if options.none?

    options.to_h.select { |_k, v| values.include?(v.to_s) }.keys
  end

  def options
    field['options'].map { |option| [option['label'], option['value']] }
  end

  def payload(job_application)
    { locator:, interaction: converted_type, value: answered_value(job_application) }
  end

  def selector = field['selector'] || field['name'].to_s

  def type = field['type']

  def valid?
    if checkbox? || radiogroup?
      options&.count&.positive?
    else
      true
    end
  end
end
