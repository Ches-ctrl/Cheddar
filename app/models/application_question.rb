# frozen_string_literal: true

class ApplicationQuestion
  # == PORO - Accessors =====================================================
  attr_accessor :section, :attribute, :label, :fields, :group_id, :required, :description, :sub_questions

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
  def attachment? = photo? || resume?
  def boolean? = type.eql?("boolean")
  def checkbox? = type.eql?("checkbox")
  def cover_letter? = attribute&.include?("cover_letter")
  def date_picker? = type.eql?("date_picker")
  # Daniel's edit below:
  def group? = type.eql?("group")
  def input? = type.eql?("input") || type.eql?("education_input")
  def linkedin_related? = attribute&.include?('linkedin')
  def multi_select? = type.eql?("multi_select")
  def photo? = attribute.eql?("photo")
  def radiogroup? = type.eql?("radiogroup")
  def resume? = attribute.eql?("resume")
  def select? = type.eql?("select") || type.eql?("education_select")
  # Daniel's edit below:
  def sub_question? = group_id.present?
  def textarea? = type.eql?("textarea")
  def upload? = type.eql?("upload")

  def boolean_options
    [['Yes', 'true'], ['No', 'false']]
  end

  def converted_type
    return 'input' if textarea?
    return 'boolean' if agreement_checkbox?

    type
  end

  def cover_letter_text_available?
    attribute.eql?('cover_letter') && fields.count > 1 && fields.any? { |field| field['name'].eql?('cover_letter_text') }
  end

  def field
    return fields.find { |field| field['name'].eql?('cover_letter_text') } if cover_letter_text_available?

    fields.first
  end

  def answered_value(job_application, key = nil)
    return job_application.resume.blob.url if resume? && job_application.resume.attached?
    return job_application.cover_letter.blob.url if cover_letter? && job_application.cover_letter.attached?

    value = key.present? ? job_application.additional_info[attribute][key] : job_application.additional_info[attribute] # Daniel's edit
    return value.values.last if value.is_a?(Hash) # Daniel's edit

    value = value.reject(&:blank?) if value.is_a?(Array)
    value.is_a?(Array) && value.count.eql?(1) ? value.first : value
  end

  # Daniel's edit
  def fetch_sub_questions
    sub_questions.map { |question| ApplicationQuestion.new(question.merge(section:)) }
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

  def payload(job_application, key = nil)
    { locator:, interaction: converted_type, value: payload_value(job_application, key) }
  end

  # Daniel's edit
  def payload_value(job_application, key)
    return answered_value(job_application, key) unless group?

    fetch_sub_questions.map { |question| question.payload(job_application, key) }
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
