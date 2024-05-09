module NetZeroData
  class NetZeroApi
  end
end

# Pseudocode
# Setup models for the Net Zero data providers
# Setup a main class that calls each scraper module as a sub-class
# Get all companies from each API to see what data is available
# Sources: Zero Tracker, EUNZDP, SBTi, CDP, manual data
# Note: SBTi & CDP do not have public APIs
# Note: GCAP (UNFCCC) is a wrapper on the CDP dataset
# Setup a background job that calls the service class

# Later
# Mock the API calls for testing
# Error handling - what to do if the API call fails?
# Monitoring source of the data to see % allocation
# Setup background job to update quarterly (UpdateExistingNetZeroDataJob)
# Display this data in a separate page using a standard DB structure as well as chartjs

# Notes
# Likely that there are company repetitions across the various sources

# Questions
# Need to create a unique identifier for each company so that it gets the correct data from the APIs?
# How to de-dupe companies?
# How to uniquely identify a company?
# Assigning industry and sub-industry to the companies?
