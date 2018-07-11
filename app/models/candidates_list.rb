class CandidatesList < ActiveRecord::Base

  # store :data, accessors: [ :params, :permitted_params, :changes, :previous_data ], coder: JSON
  serialize :kandidati #, coder: JSON

  def strana?
    typ_volebni_strany=="politická strana"
  end

  def ruian_data
    @ruian_data ||= HTTParty.get("http://openapi.cz/api/adresy/hledej/vse?dotaz=+kod_obce:#{kod_zastupitelstva}")["adresy"].
      first.symbolize_keys.extract!(:kod_obce, :nazev_obce, :kod_pou, :nazev_pou, :kod_orp, :nazev_orp, :kod_momc, :nazev_momc, :kod_mop, :nazev_mop, :kod_kraje, :nazev_kraje)
  end

  def ruian
    RuianAddress.new(
      mestska_cast:     ruian_data[:nazev_momc],
      mestska_cast_id:  ruian_data[:kod_momc],
      okres:            ruian_data[:nazev_okresu],
      okres_id:         ruian_data[:kod_okresu],
      obec:             ruian_data[:nazev_obce],
      obec_id:          ruian_data[:kod_obce],
      kraj:             ruian_data[:nazev_kraje],
      kraj_id:          ruian_data[:kod_kraje],
      orp:              ruian_data[:nazev_orp],
      orp_id:           ruian_data[:kod_orp]
    )
  end

  def branch
    @branch ||= BranchLocator.new(ruian).branch
  end

  def self.load_from_xlsx(candidates_list_file)
    workbook = RubyXL::Parser.parse(candidates_list_file.sheet.path)
    puts workbook.sheets.last.name
    kandidati = workbook["Kandidátní listina"].reject{ |row| row.nil? || row[0].nil? ||row[0].value.blank? }.select{ |row|
      puts row[0].value
      row[0].value.match(/\A(\d+\.|n.hradn.*)\z/)}.collect{ |row|
        begin
        {
          poradi: row[0].value.to_i==0 ? "náhr" : row[0].value.to_i,
          titul_pred: row[1].try(:value),
          jmeno: row[2].value,
          prijmeni: row[3].value,
          titul_za: row[4].try(:value),
          datum_narozeni: row[5].value.try(:to_date),
          pohlavi: row[6].value,
          povolani: row[7].value,
          obec: row[8].value,
          clenstvi_ve_strane: row[9].try(:value),
          adresa_bydliste: row[10].try(:value),
          navrhujici_strana: row[11].try(:value)
        }
        rescue
        {
          prijmeni: "Chyba importu",
          datum_narozeni: "2345-01-01"
        }
        end
      }.reject{|row| row[:prijmeni].nil?}

    self.new({
      candidates_list_file_id: candidates_list_file.id,
      druh_zastupitelstva: workbook["Hlavička"][5][1].value,
      kod_zastupitelstva: workbook["Hlavička"][6][1].value,
      nazev_zastupitelstva: workbook["Hlavička"][7][1].value,
      volebni_obvod: workbook["Hlavička"][8][1].try(:value),
      nazev_volebni_strany: workbook["Hlavička"][10][1].value,
      typ_volebni_strany: workbook["Hlavička"][11][1].value,
      nazev_strany_a_hnuti: workbook["Hlavička"][12][1].value,
      pocet_clenu_zastupitelstva: workbook["Hlavička"][14][1].value,
      zmocnenec_jmeno: workbook["Hlavička"][16][2].try(:value),
      zmocnenec_adresa: workbook["Hlavička"][17][2].try(:value),
      nahradnik_jmeno: workbook["Hlavička"][18][2].try(:value),
      nahradnik_adresa: workbook["Hlavička"][19][2].try(:value),
      kandidati: kandidati
      # kandidati: kandidati.collect{|kandidat| OpenStruct.new(kandidat)}
    })
  end
end
