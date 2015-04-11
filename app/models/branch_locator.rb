# -*- encoding : utf-8 -*-

class BranchLocator
  attr_accessor :mestska_cast, :obec, :obec_id, :okres, :kraj, :branch

  def initialize(options)
    @mestska_cast = options[:mestska_cast]
    @obec = options[:obec]
    @obec_id = options[:obec_id]
    @okres = options[:okres]
    @kraj = options[:kraj]
  end

  def name
    name_by_mestska_cast || name_by_obec || name_by_okres
  end

  def branch
    @branch ||= Branch.find_by_name(name)
  end

  # Pobočky na celém území městské části
  def name_by_mestska_cast
    # Jihomoravský kraj
    return mestska_cast if ["Brno-střed", "Brno-sever", "Brno-Žabovřesky", "Brno-Kohoutovice"].member?(mestska_cast)
    return "Brno-Bystrc" if ["Brno-Bystrc", "Brno-Kníničky", "Brno-Komín", "Brno-Žebětín"].member?(mestska_cast)
    return "Brno-východ" if ["Brno-Líšeň", "Brno-Vinohrady", "Brno-Židenice", "Brno-Slatina"].member?(mestska_cast)
    # Plzeňský kraj
    return "Městský obvod Plzeň 1" if mestska_cast=="Plzeň 1"
    return "Městská část Plzeň 2" if mestska_cast=="Plzeň 2-Slovany"
    return "Městská část Plzeň 3" if mestska_cast=="Plzeň 3"
    # Praha
    return mestska_cast if obec=="Praha"
  end

  # Pobočky na celém území obce
  def name_by_obec
    # Jihočeský kraj
    return obec if obec=="České Budějovice"
    return "Týn nad Vltavou" if [544281, 551503, 544515, 544540, 544639, 535982, 544809, 544817, 544868, 544884, 535231, 535699, 545023, 545104, 545171, 545376].include?(obec_id)
    # Jihomoravský kraj
    return obec if ["Břeclav", "Hodonín", "Moravský Krumlov"].member?(obec)
    return "Kuřimsko" if [583251, 583430, 583791, 583171, 584151].include?(obec_id)
    # kraj Vysočina
    return "Město Jihlava" if obec=="Jihlava"
    # Královehradecký kraj
    return obec if ["Hradec Králové", "Nový Bydžov", "Chlumec", "Hořice", "Týniště", "Vrchlabí", "Tětín", "Vítězná"].member?(obec)
    # Olomoucký kraj
    return obec if ["Olomouc", "Přerov"].member?(obec)
    # Pardubický kraj
    return obec if obec=="Chrudim"
    # Zlínský kraj
    return obec if obec=="Ostrožská Nová Ves"
  end

  # Pobočky na celém okresu
  def name_by_okres
    # Jihočeský kraj
    return "okres Český Krumlov" if okres=="Český Krumlov"
    return "okres Prachatice" if okres=="Prachatice"
    return "okres Písek" if okres=="Písek"
    return "okres Strakonice" if okres=="Strakonice"
    return "okres Tábor" if okres=="Tábor"
    return "okres Jindřichův Hradec" if okres=="Jindřichův Hradec"
    return "okres České Budějovice" if okres =="České Budějovice"
    # Jihomoravský kraj
    return "Blanensko" if okres == "Blansko"
    return "Hodonínsko" if okres == "Hodonín"
    return "Znojemsko" if okres == "Znojmo"
    return "Břeclavsko" if okres == "Břeclav"
    # kraj Vysočina
    return "Okres Jihlava" if okres=="Jihlava"
    # Pardubická kraj
    return okres if okres == "Pardubice"
    # Plzeňský kraj
    return "Okres Plzeň-sever" if okres == "Plzeň-sever"
    return "Okres Rokycany" if okres == "Rokycany"
    # Středočeský kraj
    return okres if ["Benešov", "Beroun", "Kolín", "Kutná Hora", "Mělník", "Mladá Boleslav", "Nymburk", "Praha-východ", "Praha-západ", "Příbram", "Rakovník", "Kladno"].member?(okres)
    # Ústecký kraj
    return okres if ["Děčín", "Chomutov", "Litoměřice", "Most", "Roudnice nad Labem", "Ústí nad Labem", "Žatec"].member?(okres)
    return "Bílina" if okres == "Teplice"
    # Zlínský kraj
    return "okres Vsetín" if okres =="Vsetín"
    return "okres Zlín" if okres =="Zlín"
    return "okres Kroměříž" if okres =="Kroměříž"
    return "okres Uherské Hradiště" if okres =="Uherské Hradiště"
  end

  def self.find_by_person(person)
    return false if person.domestic_ruian_address.nil?
    return BranchLocator.new(person.domestic_ruian_address)
  end
end
