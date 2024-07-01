# frozen_string_literal: true

class ApplicationCriteria
  # == PORO - Accessors =====================================================
  attr_accessor :attribute, :interaction, :locators, :required, :label, :core_field, :options

  # == Attributes ===========================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Constants ============================================================
  # == Extensions ===========================================================
  # == Initialize ============================================================
  def initialize(criteria_hash)
    criteria_hash.each do |key, value|
      # Check for valid attributes before assigning (optional)
      public_send("#{key}=", value) if respond_to?(key.to_sym)
    end
  end

  # == Instance Methods =====================================================
  # == Relationships ========================================================
  # == Scopes ===============================================================
  # == Validations ==========================================================
  def input? = interaction.eql?("input")
  def upload? = interaction.eql?("upload")
  def select? = interaction.eql?("select")
  def textarea? = interaction.eql?("textarea")
  def radiogroup? = interaction.eql?("radiogroup")
  def checkbox? = interaction.eql?("checkbox")

  def value(json)
    json&.dig(locators)
  end

  def multi_checkbox?
    interaction.eql?("checkbox") && (options&.count&.> 1)
  end

  def valid?
    return false if locators.to_s.include?("input[data-ui=")

    if checkbox? || radiogroup?
      options&.count&.positive?
    else
      true
    end
  end
end
