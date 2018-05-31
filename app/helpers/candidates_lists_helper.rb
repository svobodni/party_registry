module CandidatesListsHelper
  def genitivize(druh_zastupitelstva)
    case druh_zastupitelstva
    when /Zastupitelstvo (.*)/
      "zastupitelstva #{Regexp.last_match[1]}"
    else
      druh_zastupitelstva
    end
  end

  def cele_jmeno(kandidat)
    jmeno=kandidat[:titul_pred].blank? ? '' : "#{kandidat[:titul_pred]} "
    jmeno+=[kandidat[:jmeno], kandidat[:prijmeni]].join(' ')
    jmeno+=kandidat[:titul_za].blank? ? '' : ", #{kandidat[:titul_za]}"
  end
end
