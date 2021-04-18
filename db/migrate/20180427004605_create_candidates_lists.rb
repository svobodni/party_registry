class CreateCandidatesLists < ActiveRecord::Migration[4.2]
  def change
    create_table :candidates_lists do |t|
      t.string :druh_zastupitelstva
      t.integer :kod_zastupitelstva
      t.string :nazev_zastupitelstva
      t.integer :volebni_obvod
      t.string :nazev_volebni_strany
      t.string :typ_volebni_strany
      t.string :nazev_strany_a_hnuti
      t.integer :pocet_clenu_zastupitelstva
      t.string :zmocnenec_jmeno
      t.string :zmocnenec_adresa
      t.string :nahradnik_jmeno
      t.string :nahradnik_adresa
      t.text :kandidati

      t.timestamps null: false
    end
  end
end
