module CandidatesListsHelper
  def genitivize(druh_zastupitelstva)
    case druh_zastupitelstva
    when /Zastupitelstvo (.*)/
      "zastupitelstva #{Regexp.last_match[1]}"
    else
      druh_zastupitelstva
    end
  end
end
