module Ats
  module Recruitee
    module SubmitApplication
      private

      def submit_application
        build_form_data
        puts "Here are the fields:"
        puts @fields
      end

      def build_form_data
        form_data = { 'candidate' => {} }
        @fields.each do |field|
          form_data['candidate'][field]
        end
      end
    end
  end
end
