# -*- encoding : utf-8 -*-
module ApplicationHelper

  include ActsAsTaggableOn::TagsHelper

  def page_title(value)
    @page_title = value
  end

  def flash_class(level)
    case level
    when 'notice' then "alert alert-success"
    when 'success' then "alert alert-success"
    when 'error' then "alert alert-error"
    when 'alert' then "alert alert-error"
    end
  end

  def link_to_member_application(member)
  if member.signed_application
    link_to "Podepsaná přihláška", signed_application_person_path(member, format: :pdf), class: 'btn btn-default btn-xs'
  else
    link_to "Přihláška k podpisu", application_person_path(member, format: :pdf), class: 'btn btn-default btn-xs'
  end
  end

  def datatable(id, paging=true)
    paging_html = paging ? "" : "\"paging\":   false,"
    content_tag :script do
      "$(document).ready(function() {
        $('##{id}').DataTable( {
           #{paging_html}
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
    social = %w(facebook_profile facebook_page twitter google_plus linked_in forum web blog)
    order = %w(phone email web blog skype)+social
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
          when 'skype'
            content_tag(:i, class: 'fa fa-skype'){}
          when 'google_plus'
            content_tag(:i, class: 'fa fa-google-plus'){}
          when 'forum'
            content_tag(:i, class: 'fa fa-users'){}
          when 'blog'
            content_tag(:i, class: 'fa fa-book'){}
          when 'web'
            content_tag(:i, class: 'fa fa-globe'){}
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

  def glyph_nav_link_to(icon, text, path)
    link_to ('<span class="glyphicon glyphicon-'+icon+'"></span> '+text).html_safe, path
  end

  def fa_link_to(icon, path)
    link_to ('<span class="fa fa-'+icon+'"></span>').html_safe, path
  end

  def glyph_link_to(icon, text, path)
    link_to_unless_current ('<span class="glyphicon '+(current_page?(path) ? "active " : "")+'glyphicon-'+icon+'"></span> '+text).html_safe, path
  end

  # vraci lokalizovany nazev attributu podle i18n
  # vstup: ta(:paypal_notification, :paypal)
  #        ta('paypal_notification', 'paypal')
  def ta(model_name, attribute_name)
    model_name.to_s.classify.constantize.human_attribute_name(attribute_name)
  end

  # vraci lokalizovany nazev modelu podle i18n
  # singular, pokud nepredame 2. parametr nebo predame 1
  # plural, v ostatnich pripadech
  # (pri vychozim pluralizacnim nastaveni i18n)
  # vstup: tm(:domain, 2)
  #        tm(:domain)
  #        tm('domain', 2)
  #        tm('domain')
  def tm(model_name, count = 1)
    model_name.to_s.classify.constantize.model_name.human(:count => count)
  end

  def flash_class(level)
    case level
    when 'notice' then "alert alert-success"
    when 'success' then "alert alert-success"
    when 'error' then "alert alert-error"
    when 'alert' then "alert alert-error"
    end
  end

  def action_button_to(task)
    res = ''
    if can? :assign, task
      res = button_to('Přidělit', task_assign_path(task), method: :put, class: 'btn btn-success')
    end
    if (can? :finish, task) && res.empty?
      res = button_to('Dokončit', task_finish_path(task), method: :put, class: 'btn btn-danger')
    end
    if (can? :review, task) && res.empty?
      res = button_to('Akceptovat', task_review_path(task), method: :put, class: 'btn btn-info')
    end
    res
  end
end
