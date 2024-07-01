# frozen_string_literal: true

class HashSerializer
  def self.dump(hash)
    hash
  end

  def self.load(hash)
    (hash || {}).with_indifferent_access
  end
end
