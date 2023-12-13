require 'open-uri'
require 'json'

url = 'http://universities.hipolabs.com/search?'

response = URI.open(url).read
data = JSON.parse(response)


# Gets all 9949 universities
universities_global = data.map do |university|
  university['name']
end

universities_global.sort!
# puts universities_global


# Gets only US and GB universities (2451)
universities = []

data.select do |university|
  if university['alpha_two_code'] == 'US' || university['alpha_two_code'] == 'GB'
    universities <<  {university['name'] => university["domains"].first}
  end
end

universities.sort_by {|uni| uni.keys.first }
# puts universities


# Gets only universities of given country codes (1050)
country_codes = ['GB', 'FR', 'NL', 'SE', 'DK', 'DE', 'CH', 'ES']

universities = []

data.select do |university|
  if country_codes.include?(university['alpha_two_code'])
    universities <<  {university['name'] => university["domains"].first}
  end
end

universities.sort_by! {|uni| uni.keys.first }
# p universities

# Gets only universities of given country codes (1050)
country_codes = ['GB', 'FR', 'NL', 'ES', 'US']

universities = []

data.select do |university|
  if country_codes.include?(university['alpha_two_code'])
    universities <<  {university['name'] => university["domains"].first}
  end
end

# universities.append('Stanford University', 'Massachusetts Institute of Technology', 'Harvard University', 'Princeton University', 'California Institute of Technology', 'University of California',
#   'Yale University', 'The University of Chicago', 'Johns Hopkins University', 'University of Pennsylvania', 'Columbia University', 'Cornell University', 'University of Michigan-Ann Arbor',
# 'Carnegie Mellon University', 'University of Washington', 'Duke University', 'New York University', 'Northwestern University', 'University of California', 'Georgia Institute of Technology',
# 'University of California', 'University of Illinois', 'University of Texas', 'University of Wisconsin-Madison',
# 'Brown University', 'Boston University',
# 'University of Minnesota', 'Purdue University West Lafayette', 'Vanderbilt University', 'Ohio State University', 'Emory University',
# 'University of Maryland', 'Michigan State University', 'Texas A&M University', 'Rice University', 'Penn State', 'University of Massachusetts',
# 'University of Florida', 'University of Rochester', 'University of Colorado Boulder', 'University of Pittsburgh',
# 'University of Arizona', 'Dartmouth College', 'Case Western Reserve University', 'University of Virginia', 'Arizona State University', 'Georgetown University', 'Tufts University')


universities.sort_by! {|uni| uni.keys.first }
p universities
