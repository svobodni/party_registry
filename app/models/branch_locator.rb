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
    return mestska_cast if obec=="Praha"
    return mestska_cast if ["Brno-střed", "Brno-Žabovřesky", "Brno-Kohoutovice"].member?(mestska_cast)
    return "Městský obvod Plzeň 1" if mestska_cast=="Plzeň 1"
    return "Městská část Plzeň 2" if mestska_cast=="Plzeň 2-Slovany"
    return "Městská část Plzeň 3" if mestska_cast=="Plzeň 3"
    return "Brno-Bystrc" if ["Brno-Bystrc", "Brno-Kníničky", "Brno-Komín", "Brno-Žebětín"].member?(mestska_cast)
    return "Brno-východ" if ["Brno-Líšeň", "Brno-Vinohrady", "Brno-Židenice", "Brno-Slatina"].member?(mestska_cast)
  end

  # Pobočky na celém území obce
  def name_by_obec
    return obec if ["Hradec Králové", "Nový Bydžov", "Chlumec", "Hořice", "Týniště", "Vrchlabí", "Tětín", "Vítězná",
      "Olomouc", "Přerov", "České Budějovice","Břeclav", "Hodonín", "Moravský Krumlov"].member?(obec)
    return "Město Jihlava" if obec=="Jihlava"
    return "Týn nad Vltavou" if [544281, 551503, 544515, 544540, 544639, 535982, 544809, 544817, 544868, 544884, 535231, 535699, 545023, 545104, 545171, 545376].include?(obec_id)
    return "Kuřimsko" if [583251, 583430, 583791, 583171, 584151].include?(obec_id)
  end

  # Pobočky na celém okresu
  def name_by_okres
    return okres if ["Benešov", "Beroun", "Kolín", "Kutná Hora", "Mělník", "Mladá Boleslav", "Nymburk", "Praha-východ", "Praha-západ", "Příbram", "Rakovník", "Kladno"].member?(okres)
    return "Okres Plzeň-sever" if okres == "Plzeň-sever"
    return "Okres Rokycany" if okres == "Rokycany"
    return "Hodonínsko" if okres == "Hodonín"
    return "Znojemsko" if okres == "Znojmo"
    return "Břeclavsko" if okres == "Břeclav"
    return "Blanensko" if okres == "Blansko"
    return "okres Český Krumlov" if okres=="Český Krumlov"
    return "okres Prachatice" if okres=="Prachatice"
    return "okres Písek" if okres=="Písek"
    return "okres Strakonice" if okres=="Strakonice"
    return "okres Tábor" if okres=="Tábor"
    return "okres Jindřichův Hradec" if okres=="Jindřichův Hradec"
    return "Okres Jihlava" if okres=="Jihlava"
    return "okres České Budějovice" if okres =="České Budějovice"
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
