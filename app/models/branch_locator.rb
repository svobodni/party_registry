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
    return "Brno" if [
      "Brno-střed", "Brno-sever", "Brno-Žabovřesky", "Brno-Kohoutovice",
      "Brno-Královo pole", "Brno-Bystrc", "Brno-Kníničky", "Brno-Komín",
      "Brno-Žebětín", "Brno-Líšeň", "Brno-Vinohrady", "Brno-Židenice",
      "Brno-Slatina"].member?(mestska_cast)
    # Praha
    return mestska_cast if obec=="Praha"
  end

  # Pobočky na celém území obce
  def name_by_obec
    # Jihomoravský kraj
    return obec if ["Hodonín", "Moravský Krumlov", "Břeclav"].member?(obec)
    return "Kuřimsko" if [583251, 583430, 583791, 583171, 584151].include?(obec_id)
    # kraj Vysočina
    return "Město Jihlava" if obec=="Jihlava"
    # Karlovarský kraj
    return obec if obec=="Cheb"
    # Královehradecký kraj
    return obec if ["Hradec Králové", "Nový Bydžov", "Chlumec", "Hořice", "Týniště", "Vrchlabí", "Tětín", "Vítězná"].member?(obec) && kraj_id==86
    # Pardubický kraj
    return obec if obec=="Chrudim"
    # Středočeský kraj
    return obec if ["Slaný", "Řevnice", "Lysá nad Labem"].member?(obec)
    #  Jesenice, Vestec, Dolní Břežany, Psáry, Zlatníky-Hodkovice a Průhonice
    return "Jesenice" if [539325, 513458, 539210, 539597, 539881, 539571].include?(obec_id)
    # Ústecký kraj
    return obec if obec=="Štětí"
    # Zlínský kraj - Lechotice a Míškovice patří do pobočky Otrokovice
    return "Otrokovice" if [588661, 588750].include?(obec_id)
  end

  # Pobočky na celém území působnosti obce s rozšířenou působností
  def name_by_orp
    # Středočeský kraj
    if kraj_id == 27
      return orp if orp=="Brandýs nad Labem-Stará Boleslav"
      return "Říčansko" if orp=="Říčany"
    # Jihočeský kraj
    elsif kraj_id == 35
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
    return "Kroměříž" if ["Bystřice pod Hostýnem", "Holešov", "Kroměříž"].member?(orp)
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
    return "Okres Plzeň-město" if okres == "Plzeň-město"
    return "Okres Plzeň-jih" if okres == "Plzeň-jih"
    return "Okres Rokycany" if okres == "Rokycany"
    return "Okres Klatovy" if okres == "Klatovy"
    return "Okres Domažlice" if okres == "Domažlice"
    return "Okres Tachov" if okres == "Tachov"
    # Olomoucký kraj
    return "okres Jeseník" if okres == "Jeseník"
    return "okres Prostějov" if okres == "Prostějov"
    return "okres Šumperk" if okres == "Šumperk"
    return "okres Olomouc" if okres == "Olomouc"
    return "okres Přerov" if okres == "Přerov"
    # Středočeský kraj
    return okres if ["Benešov", "Beroun", "Kolín", "Kutná Hora", "Mělník", "Mladá Boleslav", "Nymburk", "Praha-západ", "Příbram", "Rakovník", "Kladno"].member?(okres)
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
