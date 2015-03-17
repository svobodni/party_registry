# -*- encoding : utf-8 -*-
module ApplicationHelper
  def page_title(value)
    @page_title = value
  end

  def link_to_member_application(member)
  if member.signed_application
    link_to "Podepsaná btn", signed_application_person_path(member, format: :pdf), class: 'btn btn-default btn-xs'
  else
    link_to "Přihláška k podpisu", application_person_path(member, format: :pdf), class: 'btn btn-default btn-xs'
  end
  end

  def datatable(id)
    content_tag :script do
      "$(document).ready(function() {
        $('##{id}').DataTable( {
           \"language\": {
             \"sProcessing\":   \"Provádím...\",
             \"sLengthMenu\":   \"Zobraz záznamů _MENU_\",
             \"sZeroRecords\":  \"Žádné záznamy nebyly nalezeny\",
             \"sInfo\":         \"Zobrazuji _START_ až _END_ z celkem _TOTAL_ záznamů\",
             \"sInfoEmpty\":    \"Zobrazuji 0 až 0 z 0 záznamů\",
             \"sInfoFiltered\": \"(filtrováno z celkem _MAX_ záznamů)\",
             \"sInfoPostFix\":  \"\",
             \"sSearch\":       \"Hledat:\",
             \"sUrl\":          \"\",
             \"oPaginate\": {
                \"sFirst\":    \"První\",
                \"sPrevious\": \"Předchozí\",
                \"sNext\":     \"Další\",
                \"sLast\":     \"Poslední\"
             }
          }
        } );
       } );".html_safe
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
    social = %w(facebook_profile facebook_page twitter google_plus linked_in web blog)
    order = %w(phone email web blog)+social
    contacts.sort_by{|element|
      order.index(element.contact_type)
    }.collect do |contact|
      if social.member?(contact.contact_type)
        content_tag :a, href: contact.contact, type: :button, class: 'btn btn-default' do
          case contact.contact_type
          when 'facebook_profile'
            content_tag(:i, class: 'fa fa-facebook'){}
          when 'facebook_page'
            content_tag(:i, class: 'fa fa-facebook'){}
          when 'twitter'
            content_tag(:i, class: 'fa fa-twitter'){}
          when 'linked_in'
            content_tag(:i, class: 'fa fa-linkedin'){}
          when 'google_plus'
            content_tag(:i, class: 'fa fa-google-plus'){}
          when 'blog'
            'blog'
          when 'web'
            'web'
          end
        end
      else
        content_tag :div do
          case contact.contact_type
          when 'web'
            link_to "web", contact.contact, class: 'btn btn-default'
          when 'blog'
            link_to "blog", contact.contact, class: 'btn btn-default'
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

  def link_to_member_documents(body)
    link_to "Dokumenty pro členy", "https://files.svobodni.cz/#{body.acronym.downcase}/pro-členy/"
  end


  def alert_class_for(flash_type)
    {
      :success => 'alert-success',
      :error => 'alert-danger',
      :alert => 'alert-warning',
      :notice => 'alert-info'
      }[flash_type.to_sym] || flash_type.to_s
  end

  def current_controller?(*args)
    args.any? { |v| v.to_s.downcase == controller.controller_name }
  end

  def current_action?(*args)
    args.any? { |v| v.to_s.downcase == action_name }
  end

end
