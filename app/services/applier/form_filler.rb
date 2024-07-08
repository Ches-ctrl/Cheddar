# frozen_string_literal: true

module Applier
  class FormFiller < ApplicationTask
    include Capybara::DSL
    def initialize(payload)
      @url = payload[:apply_url]
      @fields = payload[:fields]
      @session = Capybara::Session.new(:selenium)
    end

    def call
      return false unless processable

      process
    end

    private

    def processable
      @url && @fields
    end

    def process
      visit_url
      click_apply_button
      fill_in_fields
      sleep 10
    ensure
      @session.quit
    end

    def click_apply_button
      true
    end

    def fill_in_fields
      @fields.each do |field|
        case field[:interaction]
        when :input
          @session.fill_in(field[:locator], with: field[:value])
        when :radiogroup
          select_option_from_radiogroup(field)
        end
      end
    rescue Capybara::ElementNotFound
      nil
    end

    def select_option_from_radiogroup(field)
      @session.within(field[:locator]) do
        @session.find(field[:locator], text: field[:value]).click
      end
    end

    def visit_url
      @session.visit(@url)
      p "Successfully reached #{@url}"
    end
  end
end
