class NumberTester
  include ActiveSupport::NumberHelper

  def initialize
    num = 56_000
    p number_to_currency(num)
  end
end
