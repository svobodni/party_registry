# -*- encoding : utf-8 -*-
require 'elasticsearch'

class RuianAddress < ActiveRecord::Base

  geocoded_by :address_line
  attr_accessor :address_line

  before_save :load_ruian_data

  def load_ruian_data
    data = HTTParty.get("http://openapi.xnet.cz/api/adresy/#{self.id}")['adresy']
    if data
      self.mestska_cast    = data["nazev_momc"]
      self.mestska_cast_id = data["kod_momc"]
      self.okres           = data["nazev_okresu"]
      self.okres_id        = data["kod_okresu"]
      self.obec            = data["nazev_obce"]
      self.obec_id         = data["kod_obce"]
    else
      puts "#{self.id} NOT FOUND"
    end
  end

  def self.import(id)
    RuianAddress.where(id: id).first_or_create
  end

  def self.find_in_es_by_id(id)
    client = Elasticsearch::Client.new  host: 'openapi.xnet.cz:9200', log: true
    client.get_source index: 'ruian', type: 'adresni_misto', id: id
  end

  def address_line
    @address_line ||= RuianAddress.find_in_es_by_id(id)["suggest"]["output"]
  end

  def self.initialize_by_address_line(line)
    client = Elasticsearch::Client.new host: 'openapi.xnet.cz:9200' # log: true
    search = client.search index: 'ruian', body: { query: { multi_match: { query: line, use_dis_max: false, fields: [ "nazev_ulice", "cislo_orientacni", "cislo_domovni", "psc", "nazev_obce", "nazev_casti_obce", "nazev_mop"]} } }
    if search["hits"]["total"]!=0 && search["hits"]["hits"].first["_score"].to_f>0.2
      #puts line
      #puts search["hits"]["hits"].first["_source"]["suggest"]["input"] + ' [' +
      #  search["hits"]["hits"].first["_source"]["nazev_casti_obce"] + ']'
      #puts search["hits"]["hits"].first["_score"]
      #puts "=============="
      hit = search["hits"]["hits"].first["_source"]
      address = find_or_initialize_by_id(hit["kod_adm"])
      address.mestska_cast = hit["nazev_momc"]
      address.mestska_cast_id = hit["kod_momc"]
      address.obec = hit["nazev_obce"]
      address.obec_id = hit["kod_obce"]
      address.kraj = hit["suggest"]["input"]
      #address.kraj_id = ares_adresa["dtt:Adresa_UIR"]["udt:Kod_kraje"]
      #address.save
      address
    end
  end

  def self.find_or_create_by_address_line(line)
    line = line.gsub('/',' ').gsub(',', ' ').gsub(/\./,' ')
    client = Elasticsearch::Client.new host: 'openapi.xnet.cz:9200', log: true
    result = (client.suggest index: 'ruian', body: { adresni_misto_suggest:
      { text: line, completion: { field: 'suggest' } } })["adresni_misto_suggest"].first["options"]
    if result.size == 1
      import(result.first["payload"]["ruian_id"])
    else
      nil
    end
  end

end
