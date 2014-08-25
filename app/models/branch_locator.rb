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
    return mestska_cast if ["Praha 2", "Praha 3", "Praha 4", "Praha 5",
      "Praha 6", "Praha 8", "Praha 10", "Praha 11", "Praha 12", "Praha 13", 
      "Praha 14"].member?(mestska_cast)
    return "Praha 1 a 5" if ["Praha 1", "Praha 16", "Praha-Lipence", "Praha-Lochkov", "Praha-Slivenec", "Praha-Velká Chuchle", "Praha-Zbraslav", "Praha-Zličín", "Praha-Řeporyje"].member?(mestska_cast)
    return "Zbytek Prahy 4" if ["Praha-Kunratice", "Praha-Libuš", "Praha-Újezd", "Praha-Šeberov"].member?(mestska_cast)
    return "Zbytek Prahy 3 a Praha 10" if ["Praha 15","Praha 22","Praha-Benice","Praha-Dolní Měcholupy","Praha-Dubeč","Praha-Kolovraty","Praha-Královice","Praha-Křeslice","Praha-Nedvězí","Praha-Petrovice","Praha-Štěrboholy"].member?(mestska_cast)
    return "Zbytek Prahy 6 a Praha 7" if ["Praha 17", "Praha 7", "Praha-Lysolaje", "Praha-Nebušice", "Praha-Přední Kopanina", "Praha-Suchdol", "Praha-Troja"].member?(mestska_cast)
    return "Zbytek Prahy 8 a Praha 9" if ["Praha 18", "Praha 19", "Praha 20", "Praha 21", "Praha 9", "Praha-Běchovice", "Praha-Březiněves", "Praha-Dolní Chabry", "Praha-Dolní Počernice", "Praha-Klánovice", "Praha-Koloděje", "Praha-Satalice", "Praha-Vinoř", "Praha-Čakovice", "Praha-Ďáblice"].member?(mestska_cast)
    return "Městský obvod Plzeň 1" if mestska_cast=="Plzeň 1"
    return "Městská část Plzeň 2" if mestska_cast=="Plzeň 2-Slovany"
    return "Městská část Plzeň 3" if mestska_cast=="Plzeň 3"
  end

  # Pobočky na celém území obce
  def name_by_obec
    return obec if ["Hradec Králové", "Nový Bydžov", "Chlumec", "Hořice", "Týniště", "Vrchlabí", "Tětín", "Vítězná", 
      "Olomouc", "Přerov", "České Budějovice"].member?(obec)
    return "Město Jihlava" if obec=="Jihlava"
    return "Týn nad Vltavou" if [544281, 551503, 544515, 544540, 544639, 535982, 544809, 544817, 544868, 544884, 535231, 535699, 545023, 545104, 545171, 545376].include?(obec_id)
  end

  # Pobočky na celém okresu
  def name_by_okres
    return okres if ["Benešov", "Beroun", "Kolín", "Kutná Hora", "Mělník", "Mladá Boleslav", "Nymburk", "Praha-východ", "Praha-západ", "Příbram", "Rakovník", "Kladno"].member?(okres)
    return "Okres Plzeň-sever" if okres == "Plzeň-sever"
    return "Okres Rokycany" if okres == "Rokycany"
    return "Hodonínsko" if okres == "Hodonín"
    return "Znojemsko" if okres == "Znojmo"
    return "Vyškovsko" if okres == "Vyškov"
    return "okres Český Krumlov" if okres=="Český Krumlov"
    return "okres Prachatice" if okres=="Prachatice"
    return "okres Písek" if okres=="Písek"
    return "okres Strakonice" if okres=="Strakonice"
    return "okres Tábor" if okres=="Tábor"
    return "okres Jindřichův Hradec" if okres=="Jindřichův Hradec"
    return "Okres Jihlava" if okres=="Jihlava"
    return "okres České Budějovice" if okres =="České Budějovice"
  end

  def self.find_by_person(person)
    return false if person.domestic_ruian_address.nil?
    return BranchLocator.new(person.domestic_ruian_address)
  end
end