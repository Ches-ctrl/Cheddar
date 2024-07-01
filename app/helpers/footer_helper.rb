module FooterHelper
  def social_links
    [
      {
        sr_text: 'Follow us on X',
        icon_name: 'logos/x',
        link: 'https://x.com'
      },
      {
        sr_text: 'Follow us on Github',
        icon_name: 'logos/github',
        link: 'https://www.github.com/Ches-ctrl/Cheddar'
      },
      {
        sr_text: 'Join our Discord server',
        icon_name: 'logos/discord'
      },
      # {
      #   sr_text: 'Follow us on LinkedIn',
      #   icon_name: 'logos/linkedin',
      #   link: 'https://www.linkedin.com/company/Cheddarjobs'
      # }
    ]
  end

  def footer_social_links
    content_tag :div, class: 'flex gap-4' do
      social_links.map do |link|
        link_to link[:link], class: 'group' do
          concat(content_tag(:span, link[:sr_text], class: 'sr-only'))
          concat(inline_svg_tag("template/icons/#{link[:icon_name]}.svg"))
        end
      end.join.html_safe
    end
  end
end
