module Standardizer
  class TermStandardizer
    def initialize(job = nil)
      @job = job
      @map = YAML.load_file(Rails.root.join('config', 'term_mapping.yml'))['regex'].with_indifferent_access
    end

    def standardize
      categories = %i[employment_type seniority]

      categories.each do |category|
        term = @job.send(category)
        replacement = standardize_term(term, category)
        @job.update_attribute(category, replacement) unless term == replacement
      end
    end

    def standardize_term(term, category)
      return unless term && category

      keywords = @map[category]
      match = keywords.find do |k, v|
        exp = Regexp.new(k, Regexp::IGNORECASE)
        break v if term.match?(exp)
      end
      match || term
    end

    private

    def fetch_all(categories)
      default_map = {}

      categories.each_value do |sub_mappings|
        default_map.merge!(sub_mappings)
      end

      default_map
    end
  end
end
