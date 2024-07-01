module JsonOutputHelper
  def last_element?(hash, key)
    return false if hash.empty? || !hash.key?(key)

    hash.keys.size.eql?(hash.keys.index(key) + 1)
  end
end
