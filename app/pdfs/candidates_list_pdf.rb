class CandidatesListPdf < Prawn::Document
  include CandidatesListsHelper
  def initialize(candidates_list, print_date='2018-07-31')
    super(page_layout: :landscape)

    extend ActionView::Helpers::NumberHelper
    extend ActionView::Helpers::TagHelper
    extend ActionView::Helpers::TranslationHelper

    font_families['Montserrat'] = {
      :normal => { :file => File.join(Rails.root, 'fonts', 'Montserrat-Regular.ttf') },
    }
    font 'Montserrat', :size => 8

    width = bounds.width
    line_height = height_of('X')
    vspace = 15

    pad = 20
    width = bounds.width-2*pad
    bounding_box([pad, bounds.height - pad], :width => bounds.width - (pad * 2), :height => bounds.height - (pad * 2)) do

    image  File.join(Rails.root, 'app', 'assets', 'images', 'Svobodni_logo_RGB.png'), width: 150

    move_down vspace

    # text('Kandidátní listina pro volby do Poslanecké sněmovny Parlamentu České republiky', {
    text("Kandidátní listina pro volby do #{genitivize candidates_list[:druh_zastupitelstva]} #{candidates_list[:nazev_zastupitelstva]} ", {
      :size => 16,
      :styles => [:bold],
      :align => :center
    })
    # move_down vspace
    text('konané ve dnech 5. a 6. října 2018', {
      :size => 16,
      :styles => [:bold],
      :align => :center
    })

    text("volební obvod č. #{candidates_list.volebni_obvod}", {
      :size => 16,
      :styles => [:bold],
      :align => :center
    }) if candidates_list[:volebni_obvod]

    # move_down vspace
    table([
       # ["Volební kraj:", area.name],
       ["Název volební strany:", candidates_list[:nazev_volebni_strany]],
       ["Typ volební strany:", candidates_list[:typ_volebni_strany]],
       ["Název strany a hnutí:", candidates_list[:nazev_strany_a_hnuti]],
       ["Kandidáti:"]
    ]) do
      cells.borders = []
    end

    if candidates_list.strana?
    table([["pořadí","jméno a příjmení", "pohlaví", "věk", "povolání", "obec trvalého pobytu", "Název politické strany, jejíž je kandidát členem"]]+candidates_list.kandidati.collect{|c|
      ["#{c[:poradi]}.", cele_jmeno(c), c[:pohlavi], "#{vek(c, print_date)} let", c[:povolani], c[:obec], c[:clenstvi_ve_strane]]
    }, column_widths: [40, 140, 40, 40, 220, 80, 120])
    else
      table([["pořadí","jméno a příjmení", "pohlaví", "věk", "povolání", "obec trvalého pobytu", "Název politické strany, jejíž je kandidát členem", "Navrhující strana"]]+candidates_list.kandidati.collect{|c|
        ["#{c[:poradi]}.", cele_jmeno(c), c[:pohlavi], "#{vek(c, print_date)} let", c[:povolani], c[:obec], c[:clenstvi_ve_strane], c[:navrhujici_strana]]
      }, column_widths: [30, 120, 30, 30, 200, 70, 80, 80])
    end

#{c.age(print_date)} let
    start_new_page

    move_down vspace
    text("Zmocněnec politické strany", {
      size: 12,
    })

    move_down vspace
    text("Jméno a přijmení: "+ (candidates_list.zmocnenec_jmeno || "."*100))

    move_down vspace
    text("Místo, kde je přihlášen k trvalému pobytu: "+ (candidates_list.zmocnenec_adresa || "."*200))

    move_down vspace
    text("Náhradník zmocněnce politické strany", { size: 12 })

    move_down vspace
    text("Jméno a přijmení: "+ (candidates_list.nahradnik_jmeno || "."*100))

    move_down vspace
    text("Místo, kde je přihlášen k trvalému pobytu: "+ (candidates_list.nahradnik_adresa || "."*200))

    move_down vspace*4
    text("."*100)
    text("Podpis zmocněnce politické strany")

    move_down vspace
    text("Osoba oprávněná jednat jménem politické strany", { size: 12 })
    move_down vspace
    text("Jméno, příjmení a označení funkce: Tomáš Pajonk, předseda")

    move_down vspace*4
    text("."*100)
    text("Podpis oprávněné osoby")

    move_down vspace
    text("V .................................... dne .............................")

    move_down vspace
    text("Přílohy:")
    text("  Prohlášení kandidáta")
    # text("  Potvrzení o složení příspěvku na volební náklady")

    number_pages "strana <page>/<total>", { :at => [0, 0], :align => :center, :size => 8}

   end
 end
end
