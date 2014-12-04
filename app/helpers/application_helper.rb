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
end
