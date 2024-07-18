# frozen_string_literal: true

class ApplicationQuestion
  # == PORO - Accessors =====================================================
  attr_accessor :attribute, :label, :fields, :required, :description

  # == Attributes ===========================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Constants ============================================================
  # == Extensions ===========================================================
  # == Initialize ============================================================
  def initialize(questions_params)
    # questions_params.each.each.each.each do |key, value|
    #   # Check for valid attributes before assigning (optional)
    #   public_send("#{key}=", value) if respond_to?(attribute)
    #   # question_params['attribute']
    # end
    # question_hash = questions_params.first # Assuming first element is a hash
    questions_params.map do |key, value|
      public_send("#{key}=", value) # if respond_to?(attribute)
    end
  end

  # == Instance Methods =====================================================
  # == Relationships ========================================================
  # == Scopes ===============================================================
  # == Validations ==========================================================

  def checkbox? = type.eql?("checkbox")
  def cover_letter? = attribute.include?("cover_letter")
  def input? = type.eql?("input_text")
  def radiogroup? = type.eql?("radiogroup")
  def resume? = attribute.eql?("resume")
  def select? = type.eql?("select")
  def textarea? = type.eql?("textarea")
  def upload? = type.eql?("upload")

  def field = fields.first

  def multi_checkbox?
    type.eql?("checkbox") && (options&.count&.> 1)
  end

  def payload(job_application)
    { attribute: { input_text: type, value: answered_value(job_application) } }
  end

  def selector = fields.first['selector']

  def type = fields.first['type']

  def answered_value(job_application)
    return job_application.resume.blob.url if resume? && job_application.resume.attached?
    return job_application.cover_letter.blob.url if cover_letter? && job_application.cover_letter.attached?

    job_application.additional_info[attribute]
  end

  def valid?
    if checkbox? || radiogroup?
      options&.count&.positive?
    else
      true
    end
  end
end
