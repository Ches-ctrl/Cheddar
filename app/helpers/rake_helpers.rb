module RakeHelpers
  def prompt_for_ats
    ats_list = {
      AshbyHQ: true,
      BambooHR: true,
      Greenhouse: true,
      Workable: true
    }

    user_ready = false
    options_count = ats_list.count

    until user_ready
      display_options(ats_list)
      response = fetch_input(options_count)
      user_ready, ats_list = parse_response(ats_list, response, options_count)
    end

    ats_list
  end

  private

  def display_options(ats_list)
    system('clear') || system('cls') # depending on mac/linux
    puts "Select which Applicant Tracking Systems you'd like to test:\n"
    ats_list.each_with_index do |(name, value), index|
      spacing = ' ' * [1, 14 - name.length].max
      puts "  #{index + 1})  -  #{name}#{spacing}[#{value ? 'x' : ' '}]"
    end
  end

  def fetch_input(options_count)
    puts "\nSelect a number between 1 and #{options_count}:"
    puts "Enter 'x' to select/deselect all.\n"
    puts "Enter 'c' to commit these options."
    $stdin.gets.chomp.downcase
  end

  def parse_response(ats_list, response, options_count)
    return 1 if response == 'c'
    return select_deselect_all(ats_list) if response == 'x'

    response = response.to_i
    ats_list = select_deselect_option(ats_list, response) if response.positive? && response <= options_count
    [false, ats_list]
  end

  def select_deselect_all(ats_list)
    ats_list = ats_list.values.any?(&:blank?) ? ats_list.transform_values { true } : ats_list.transform_values { false }
    [false, ats_list]
  end

  def select_deselect_option(ats_list, response)
    index = response - 1
    key = ats_list.keys[index]
    ats_list[key] ^= true # invert the value
    ats_list
  end
end
