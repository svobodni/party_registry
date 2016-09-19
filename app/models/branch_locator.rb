# -*- encoding : utf-8 -*-

class BranchLocator
  attr_accessor :mestska_cast, :obec, :obec_id, :okres, :kraj, :kraj_id, :orp, :orp_id, :branch

  def initialize(options)
    @mestska_cast = options[:mestska_cast]
    @obec = options[:obec]
    @obec_id = options[:obec_id]
    @okres = options[:okres]
    @kraj_id = options[:kraj_id]
    @kraj = options[:kraj]
    @orp = options[:orp]
    @orp_id = options[:orp_id]
  end

  def name
    name_by_mestska_cast || name_by_obec || name_by_orp || name_by_okres
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
    return "Městský obvod Plzeň 2 – Slovany" if mestska_cast=="Plzeň 2-Slovany"
    return "Městský obvod Plzeň 3" if mestska_cast=="Plzeň 3"
    # Praha
    return mestska_cast if obec=="Praha"
  end

  # Pobočky na celém území obce
  def name_by_obec
    # Jihomoravský kraj
    return obec if ["Břeclav", "Hodonín", "Moravský Krumlov"].member?(obec)
    return "Kuřimsko" if [583251, 583430, 583791, 583171, 584151].include?(obec_id)
    # kraj Vysočina
    return "Město Jihlava" if obec=="Jihlava"
    # Karlovarský kraj
    return obec if obec=="Cheb"
    # Královehradecký kraj
    return obec if ["Hradec Králové", "Nový Bydžov", "Chlumec", "Hořice", "Týniště", "Vrchlabí", "Tětín", "Vítězná"].member?(obec) && kraj_id==86
    # Olomoucký kraj
    return obec if ["Olomouc", "Přerov"].member?(obec)
    # Pardubický kraj
    return obec if obec=="Chrudim"
    # Středočeský kraj
    return obec if ["Slaný", "Řevnice", "Lysá nad Labem"].member?(obec)
    # Ústecký kraj
    return obec if obec=="Štětí"
  end

  # Pobočky na celém území působnosti obce s rozšířenou působností
  def name_by_orp
    # Jihočeský kraj
    if kraj_id == 35
      return "Blatensko" if orp=="Blatná"
      return "Českobudějovicko" if orp=="České Budějovice"
      return "Českokrumlovsko" if orp=="Český Krumlov"
      return "Dačicko" if orp=="Dačice"
      return "Jindřichohradecko" if orp=="Jindřichův Hradec"
      return "Kaplicko" if orp=="Kaplice"
      return "Milevsko" if orp=="Milevsko"
      return "Písecko" if orp=="Písek"
      return "Prachaticko" if orp=="Prachatice"
      return "Soběslavsko" if orp=="Soběslav"
      return "Strakonicko" if orp=="Strakonice"
      return "Táborsko" if orp=="Tábor"
      return "Trhosvinensko" if orp=="Trhové Sviny"
      return "Třeboňsko" if orp=="Třeboň"
      return "Vimpersko" if orp=="Vimperk"
      return "Vltavotýnsko" if orp=="Týn nad Vltavou"
      return "Vodňansko" if orp=="Vodňany"
    elsif kraj_id==78
    # Liberecký kraj
      return orp
    end
    # kraj Vysočina
    return orp if orp=="Třebíč"
    # Zlínský kraj
    return orp if kraj_id == 141
  end

  # Pobočky na celém okresu
  def name_by_okres
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
    return "Okres Klatovy" if okres == "Klatovy"
    # Středočeský kraj
    return okres if ["Benešov", "Beroun", "Kolín", "Kutná Hora", "Mělník", "Mladá Boleslav", "Nymburk", "Praha-východ", "Praha-západ", "Příbram", "Rakovník", "Kladno"].member?(okres)
    # Ústecký kraj
    return okres if ["Děčín", "Chomutov", "Litoměřice", "Most", "Roudnice nad Labem", "Ústí nad Labem", "Žatec"].member?(okres)
    return "Žatec" if okres == "Louny"
    return "Bílina" if okres == "Teplice"
  end

  def self.find_by_person(person)
    return false if person.domestic_ruian_address.nil?
    return BranchLocator.new(person.domestic_ruian_address)
  end
end
