module Standardizer
  class RoleStandardizer
    ROLE_TITLES = {
      /back[- ]?end/ => 'back_end',
      /front[- ]?end/ => 'front_end',
      /\bui\b/ => 'front_end',
      /\bux\b/ => 'front_end',
      /design/ => 'front_end',
      /full[- ]?stack/ => 'full_stack',
      /devops/ => 'dev_ops',
      /\bqa\b/ => 'qa_test_engineer',
      /\btest\b/ => 'qa_test_engineer',
      /mobile/ => 'mobile',
      /\bios\b/ => 'mobile',
      /android/ => 'mobile',
      /react native/ => 'mobile',
      /\bdata\b/ => 'data_engineer'
    }
    ROLE_DESCRIPTORS = {
      /front[- ]?end/ => 'front_end',
      /responsive web/ => 'front_end',
      /\breact\b(?!.?native)/ => 'front_end',
      /react native/ => 'mobile',
      /reactjs/ => 'front_end',
      /figma/ => 'front_end',
      /grunt/ => 'front_end',
      /gulp/ => 'front_end',
      /webpack/ => 'front_end',
      /tailwind/ => 'front_end',
      /bootstrap/ => 'front_end',
      /\bcss\b(?!.?careers)|\bsass\b/ => 'front_end',
      /jquery/ => 'front_end',
      /html/ => 'front_end',
      /\bvue\b/ => 'front_end',
      /back[- ]?end/ => 'back_end',
      /server[- ]side/ => 'back_end',
      /cloud computing/ => 'back_end',
      /database/ => 'back_end',
      /sql\b/ => 'back_end',
      /laravel/ => 'back_end',
      /kubernetes/ => 'back_end',
      /docker/ => 'back_end',
      /\baws\b/ => 'back_end',
      /azure/ => 'back_end',
      /\bgcp\b|google cloud/ => 'back_end',
      /\bnode\b/ => 'back_end',
      /ruby on rails/ => 'back_end',
      /full[- ]?stack/ => 'full_stack',
      /mobile/ => 'mobile',
      /\bios\b/ => 'mobile',
      /android/ => 'mobile'
    }

    def initialize(job)
      @job = job
    end

    def standardize
      title_roles = ROLE_TITLES.inject([]) do |array, (keyword, role)|
        @job.title.downcase.match?(keyword) ? array << role : array
      end
      roles = ROLE_DESCRIPTORS.inject([]) do |array, (phrase, role)|
        @job.description&.downcase&.match?(phrase) ? array << role : array
      end

      if title_roles.include?('front_end')
        roles.delete('full_stack')
        roles.delete('back_end')
      elsif title_roles.include?('back_end')
        roles.delete('full_stack')
        roles.delete('front_end')
      end

      roles += title_roles
      roles.uniq!

      if roles.include?('full_stack')
        roles.delete('front_end')
        roles.delete('back_end')
      elsif roles.include?('front_end') && roles.include?('back_end')
        roles << 'full_stack'
        roles.delete('front_end')
        roles.delete('back_end')
      end

      @job.roles = []
      roles.each do |role_name|
        @job.roles << Role.find_or_create_by(name: role_name)
      end
    end
  end
end
