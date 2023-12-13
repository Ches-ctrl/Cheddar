# require 'nokogiri'

class GetHtmlJob < ApplicationJob
  include Capybara::DSL

  queue_as :default

  def perform(url)
    Capybara.default_max_wait_time = 10

    visit(url)

    begin
      # page_html = page.html
      # element = find(required_html_element)

      # TODO: Impersonate a user agent to get the full HTML as currently appears to be 'locked'
      # TODO: Refactor into separate methods for readability and to make it more efficient

      # First solution:
      # class_arr_of_required_html_element = ['col-12', 'col-sm-12', 'col-md-10', 'col-lg-8', 'col-xl-8']
      # element = find (class: class_arr_of_required_html_element, visible: :all)

      # Second solution:
      class_arr_of_required_html_element = ['col-12', 'col-sm-12', 'col-md-10', 'col-lg-8', 'col-xl-8']
      selector = class_arr_of_required_html_element.map { |cls| ".#{cls}" }.join
      element = find(selector, visible: :all)

      # p "Element:"
      # p element

      # Extract element HTML from Capybara element
      element_html = page.evaluate_script("arguments[0].outerHTML", element.native)

      # p "Element HTML:"
      # p element_html

      # Convert Capybara element to a Nokogiri element
      nokogiri_element = Nokogiri::HTML.fragment(element_html)

      # p "Nokogiri element:"
      # p nokogiri_element

      # # Remove style attributes from all elements
      nokogiri_element.traverse { |node| node.delete('style') }

      # Get the HTML content of the element element without style properties
      cleaned_html = nokogiri_element.to_html

      puts "Cleaned HTML:"
      puts cleaned_html

      puts "Length: #{cleaned_html.size} characters"
      puts "Tokens required: #{OpenAI.rough_token_count(cleaned_html)}"

    rescue Capybara::ElementNotFound => e
      puts "Element not found: #{e.message}"
    end
  end
end


# ---------------
# Extract just the relevant input elements within a form:
# ---------------

# simplified_form = Nokogiri::HTML::DocumentFragment.parse("")

# nokogiri_form.css('input, select, textarea, label').each do |element|
#   # Clone the element to modify it
#   cloned_element = element.clone

#   # Remove all attributes except the essentials
#   cloned_element.attributes.each do |name, _|
#     unless ['id', 'name', 'type', 'aria-labelledby', 'for', 'value'].include?(name)
#       cloned_element.remove_attribute(name)
#     end
#   end

#   # Add to simplified form
#   simplified_form.add_child(cloned_element)
# end

# # puts "Simplified form:"
# # puts simplified_form

# simplified_html = simplified_form.to_html

# TrueUp url: https://www.trueup.io/jobs
# TrueUp class for Job Cards: class="col-12 col-sm-12 col-md-10 col-lg-8 col-xl-8"

# Returned cleaned HTML from TrueUp:
# Cleaned HTML:
# <div class="col-12 col-sm-12 col-md-10 col-lg-8 col-xl-8"><div class="mb-4"><div class="locked"><div><div class="d-flex flex-column align-items-center align-items-lg-start"><button disabled class="ais-InfiniteHits-loadMore"><div class="mx-5 my-1 font-monospace">Show more</div></button></div></div></div></div></div>
