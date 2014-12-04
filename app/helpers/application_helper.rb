# -*- encoding : utf-8 -*-
module ApplicationHelper
  def page_title(value)
    @page_title = value
  end

  def link_to_member_application(member)
  if member.signed_application
    link_to "Podepsaná přihláška", signed_application_person_path(member, format: :pdf)
  else
    link_to "Přihláška", application_person_path(member, format: :pdf)
  end
  end

  def tel_to(number=nil)
    if number
      phone = number.gsub(/\.- /,'')
      phone = '+420'+phone if phone.length==9
      link_to phone, "tel:#{phone}"
    end
  end

  def draw_contacts(contacts)
    social = %w(facebook_profile facebook_page twitter google_plus linked_in)
    order = %w(phone email web blog)+social
    contacts.sort_by{|element|
      order.index(element.contact_type)
    }.collect do |contact|
      if social.member?(contact.contact_type)
        content_tag :a, href: contact.contact, type: :button, class: 'btn btn-default' do
          case contact.contact_type
          when 'facebook_page', 'facebook_profile'
            content_tag(:i, class: 'fa fa-facebook'){}
          when 'twitter'
            content_tag(:i, class: 'fa fa-twitter'){}
          when 'linked_in'
            content_tag(:i, class: 'fa fa-linkedin'){}
          when 'google_plus'
            content_tag(:i, class: 'fa fa-google-plus'){}
          end
        end
      else
        content_tag :div do
          case contact.contact_type
          when 'email'
            mail_to contact.contact, contact.contact
          when 'phone'
            phone = contact.contact.gsub(/\.- /,'')
            phone = '+420'+phone if phone.length==9
            link_to phone, "tel:#{phone}"
          else
            content_tag :div do
              if contact.contact.match(/^http/)
                contact.contact_type + ': ' + link_to(contact.contact, contact.contact)
              else
                contact.contact_type + ': ' + contact.contact
              end.html_safe
            end
          end
        end
      end
    end.join.html_safe
  end

end
