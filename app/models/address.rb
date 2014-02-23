class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true
  before_save :set_ruian_adresni_misto_id

  geocoded_by :address_line

  def address_line
  	"#{street}, #{zip} #{city}"
  end

  def set_ruian_adresni_misto_id
  	unless ruian_adresni_misto_id
  	  puts street.class
  	  puts address_line
  	  c=Crack::XML.parse(HTTParty.get("http://wwwinfo.mfcr.cz/cgi-bin/ares/darv_adr.cgi?adresa_textem=#{URI.escape(address_line.encode("iso-8859-2"))}&xml=0").body)
  	  if c["are:Ares_odpovedi"]["are:Odpoved"]["dtt:Stdadr_odpoved"]["dtt:Vsechna_slova"]["dtt:Pocet_nalezenych"]=="1"
	    self.ruian_adresni_misto_id = c["are:Ares_odpovedi"]["are:Odpoved"]["dtt:Stdadr_odpoved"]["dtt:Vsechna_slova"]["dtt:Seznam_navracenych"]["dtt:Adresa_ARES"]["dtt:Adresa_UIR"]["udt:Kod_adresy"]
	    self.ruian_adresni_misto_mestska_cast = c["are:Ares_odpovedi"]["are:Odpoved"]["dtt:Stdadr_odpoved"]["dtt:Vsechna_slova"]["dtt:Seznam_navracenych"]["dtt:Adresa_ARES"]["dtt:Nazev_mestske_casti"]
	  else
	  	puts c
	  end
	end
  end

end
