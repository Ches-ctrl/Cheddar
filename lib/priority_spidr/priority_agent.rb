require "spidr/agent"
require "pathname"

module Spidr
  # Subclass of Spidr::Agent that puts urls matching `priority_stubs` at the front of the scrape queue
  class PriorityAgent<Spidr::Agent
    attr_accessor :priority_stubs

    def enqueue(url, level = 0)
      url = sanitize_url(url)

      if !queued?(url) && visit?(url)
        link = url.to_s

        begin
          @every_url_blocks.each { |url_block| url_block.call(url) }

          @every_url_like_blocks.each do |pattern, url_blocks|
            match = case pattern
                    when Regexp
                      link =~ pattern
                    else
                      (pattern == link) || (pattern == url)
                    end

            url_blocks.each { |url_block| url_block.call(url) } if match
          end
        rescue Actions::Paused => e
          raise(e)
        rescue Actions::SkipLink
          return false
        rescue Actions::Action
        end
        # If the url contains any stub, it goes to the front
        if @priority_stubs.any? { |stub| url.to_s.downcase.include?(stub) }
          @queue.insert(0, url)
        else
          @queue << url
        end
        @levels[url] = level
        return true
      end

      return false
    end
  end
end
