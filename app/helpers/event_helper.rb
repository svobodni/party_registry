module EventHelper

  def humanize_event(event)
    begin
    output = []
    #output << "<i>#{event.name}</i>"
    if ['ContactCreated','ContactUpdated','ContactDeleted'].member?(event.name)
    elsif event.name=='DomesticBranchUpdated'
      output << 'byl automaticky podle adresy '
      if event.old_domestic_branch.blank?
        output << 'zařazen do pobočky '
      else
        output << "přeřazen z pobočky #{event.old_domestic_branch.try(:name) || event.old_domestic_branch_id } do pobočky "
      end
      output << (event.domestic_branch.try(:name) || event.domestic_branch_id)
      output << '.'
    elsif event.name=='PaymentAccepted'
       if event.changes['status'] && event.changes['status'][1]=="regular_member"
         output << 'zaplatil a stal se řádným členem.'
       elsif event.changes['status'] && event.changes['status'][1]=="regular_supporter"
         output << 'zaplatil a stal se příznivcem.'
       else
         output << "prodloužil do #{l event.changes['paid_till'].try(:last).try(:to_date)}"
       end
    elsif event.name=='PersonDeleted'
         output << "byl smazán z databáze."
    elsif event.name=='PersonAccepted'
      output << 'byl schválen KrP'
    elsif event.name=='SupporterRegistered'
      output << 'se zaregistroval jako příznivec'
    elsif event.name=='SupportEnded'
      output << 'ukončil příznivectví'
    elsif event.name=='ApplicationReceived'
      output << 'doručil podepsanou přihlášku'
    elsif event.name=='MembershipRequested'
      output << 'požádal o členství'
    elsif event.name=='MembershipCancelled'
      output << 'ukončil členství'
    elsif event.name=='BranchCreated'
      output << 'založena nová pobočka'
    elsif event.name=='RoleCreated'
      if event.data["changes"]["type"][1]=="Coordinator"
        output << "byl jmenován koordinátorem pobočky #{link_to(event.data["changes"]["branch_name"].try('last'), branch_path(event.data["changes"]["branch_id"].try('last')))}"
        output << ". <small>(od #{l event.data["changes"]["since"][1].to_date})</small>"
      else
        output << "byl zvolen "
        if event.data["changes"]["type"][1]=="President"
          output << "za předsedu "
        elsif event.data["changes"]["type"][1]=="Vicepresident"
          output << "za místopředsedu "
        elsif event.data["changes"]["type"][1]=="Member"
          output << "za člena "
        end
        body = Body.find(event.data["changes"]["body_id"][1])
        if body.organization_id==100
          output << link_to(body.name, body)
        else
          output << link_to(body.organization.name, body.organization)
        end
        output << ". <small>(#{l event.data["changes"]["since"][1].to_date} - #{l event.data["changes"]["till"][1].to_date})</small>"
      end
    elsif event.name=='RoleCancelled'
      if event.eventable.type=="Coordinator"
        output << "přestal být koordinátorem pobočky #{event.eventable.branch.try(:name)}"
        output << ". <small>(od #{l event.eventable.till})</small>"
      else
        output << "přestal být "
        if event.eventable.type=="President"
          output << "předsedou "
        elsif event.eventable.type=="Vicepresident"
          output << "místopředsedou "
        elsif event.eventable.type=="Member"
          output << "členem "
        end
        if event.eventable.body.organization_id==100
           output << link_to(event.eventable.body.name, event.eventable.body)
        else
           output << link_to(event.eventable.body.organization.name, event.eventable.body.organization)
        end if event.eventable.body
        output << ". <small>(#{l event.eventable.since} - #{l event.eventable.till})</small>"
      end
    elsif event.name=='PersonUpdated'
      if event.data["changes"]["domestic_region_id"]
        output << "nově patří do kraje #{event.domestic_region.try(:name)}"
      end
      if event.data["changes"]["guest_region_id"]
        output << "přestal hostovat v #{event.old_guest_region.try(:name)}" if event.old_guest_region
        output << "začal hostovat v #{event.guest_region.try(:name)}"
      end
      if event.data["changes"]["guest_branch_id"]
        output << "přestal hostovat v #{event.old_guest_branch.try(:name)}" if
        event.old_guest_branch
        output << "začal hostovat v #{event.guest_branch.try(:name)}"
      end
      if event.data["changes"]["domestic_address_ruian_id"]
        output << "dohledána adresa v RUIAN"
      end
      output = [output.join(', '),'.']
      output = ['aktualizovány ostatní údaje.'] if output==['','.']
    end
    output << event.name if output.empty?
    output.join.html_safe
  end
  rescue
    "CHYBA"
  end
end
