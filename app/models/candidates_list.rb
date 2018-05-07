class CandidatesList < ActiveRecord::Base

  # store :data, accessors: [ :params, :permitted_params, :changes, :previous_data ], coder: JSON
  serialize :kandidati #, coder: JSON

  def cele_jmeno
    "#{jmeno} #{prijmeni}"
  end

  def self.load_from_xlsx(candidates_list_file)
    workbook = RubyXL::Parser.parse(candidates_list_file.sheet.path)
    puts workbook.sheets.last.name
    kandidati = workbook["Kandidátní listina"].reject{ |row| row.nil? || row[0].value.blank? }.select{ |row|
      puts row[0].value
      row[0].value.match(/\A(\d+\.|n.hradn.*)\z/)}.collect{ |row|
        {
          poradi: row[0].value.to_i==0 ? "náhr" : row[0].value.to_i,
          titul_pred: row[1].value,
          prijmeni: row[2].value,
          jmeno: row[3].value,
          titul_za: row[4].value,
          datum_narozeni: row[5].value.try(:to_date),
          pohlavi: row[6].value,
          povolani: row[7].value,
          clenstvi_ve_strane: row[8].value,
          adresa_bydliste: row[9].value
        }
      }.reject{|row| row[:prijmeni].nil?}

    self.new({
      candidates_list_file_id: candidates_list_file.id,
      druh_zastupitelstva: workbook["Hlavička"][5][1].value,
      kod_zastupitelstva: workbook["Hlavička"][6][1].value,
      nazev_zastupitelstva: workbook["Hlavička"][7][1].value,
      volebni_obvod: workbook["Hlavička"][8][1].value,
      nazev_volebni_strany: workbook["Hlavička"][10][1].value,
      typ_volebni_strany: workbook["Hlavička"][11][1].value,
      nazev_strany_a_hnuti: workbook["Hlavička"][12][1].value,
      pocet_clenu_zastupitelstva: workbook["Hlavička"][14][1].value,
      zmocnenec_jmeno: workbook["Hlavička"][16][2].value,
      zmocnenec_adresa: workbook["Hlavička"][17][2].value,
      nahradnik_jmeno: workbook["Hlavička"][18][2].value,
      nahradnik_adresa: workbook["Hlavička"][19][2].try(:value),
      kandidati: kandidati
      # kandidati: kandidati.collect{|kandidat| OpenStruct.new(kandidat)}
    })
  end
end
