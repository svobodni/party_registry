class RuianAddress < ActiveRecord::Base

  def self.find_or_create_by_address_line(line)
    line = "Pardubická 461/39, 10400 Praha 10" if line=="Pardubická 461/36, 10400 Praha - 22 - Uhříněves,"
    line = "Panenky 355/8, 19016 Praha 9" if line=="Panenky 355, 19016 Koloděje"
    line = "5. května 1188/6, 14000 Praha 4" if line=="Tř. 5.Května 1188/6 , 14000 Praha 4"
    line = "Klausova 1460/24, 155 00 Praha" if line=="Klausova 24, 15500 Stodůlky"
    line = "Belgická 26/31, 120 00 Praha" if line=="Belgicka 26/31, 12000 Praha 2"
    line = "Na Pankráci 113, 14000 Praha 4" if line=="Na Pankraci 113, 14000 Praha 4"
    line = "Na Záhonech 19, 14100 Praha 4" if line=="Na Zahonech 19, 14100 Praha 4"
    line = "Masarykovo Nábřeží 30, 11000 Praha 1" if line=="Masarykovo Nabrezi 30, 11000 Praha 1"
    line = "Františka Diviše 1367/54d, 10400 Praha 10" if line=="Fr.Diviše 1367, 10400 Praha 22 - Uhříněves"
    line = "Závist 1175, 15600 Praha" if line=="Závist 1175, 15600 Závist"
    line = "Janovská 376, 10900 Praha" if line=="Janovska 376, 10900 Praha"
    line = "Vlašimská 4, 10100 praha 10" if line=="vlašimska 4, 10100 praha 10"
    line = "Severní I 1495/35, 14100 Praha" if line=="Severni I., 14100 Praha"
    line = "Bělčická 2828/18, 14100 Praha" if line=="Bělčická 2828/18, 14100 Záběhlice"
    line = "Kolárova 450/1, 18600 Praha 8" if line=="Kollárova 450/1, 18600 Praha 8"
    line = "Na poříčí 14, 11000 Praha" if line=="NA PORICI 14, 11000 Praha"
    line = "Naskové 1231/1b, 15000 praha" if line=="naskove 1231/1b, 15000 praha"
    line = "Blachutova 930/2, 19600 Praha" if line=="Blachutova 930/2, 19600 Čakovice"

    c=Crack::XML.parse(HTTParty.get("http://wwwinfo.mfcr.cz/cgi-bin/ares/darv_adr.cgi?adresa_textem=#{URI.escape(line.encode("iso-8859-2"))}&xml=0").body)
    if c["are:Ares_odpovedi"]["are:Odpoved"]["dtt:Stdadr_odpoved"]["dtt:Vsechna_slova"]["dtt:Pocet_nalezenych"]=="1"
      ares_adresa = c["are:Ares_odpovedi"]["are:Odpoved"]["dtt:Stdadr_odpoved"]["dtt:Vsechna_slova"]["dtt:Seznam_navracenych"]["dtt:Adresa_ARES"]
      address = find_or_initialize_by_id(ares_adresa["dtt:Adresa_UIR"]["udt:Kod_adresy"])
      address.mestska_cast = ares_adresa["dtt:Nazev_mestske_casti"]
      address.mestska_cast_id = ares_adresa["dtt:Adresa_UIR"]["udt:Kod_mestske_casti"]
      address.obec = ares_adresa["dtt:Nazev_obce"]
      address.obec_id = ares_adresa["dtt:Adresa_UIR"]["udt:Kod_obce"]
      address.kraj = ares_adresa["dtt:Nazev_kraje"]
      address.kraj_id = ares_adresa["dtt:Adresa_UIR"]["udt:Kod_kraje"]
      address.save
      address
    else
      nil
    end
  end

end
