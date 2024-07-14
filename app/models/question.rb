# frozen_string_literal: true

class Question
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
    { attribute: { input_text: type, value: value(job_application) } }
  end

  def selector = fields.first['selector']

  def type = fields.first['type']

  def value(job_application)
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
