class DeclarationPdf < Prawn::Document
  include CandidatesListsHelper
  def initialize(candidate, candidates_list)
    super()

    extend ActionView::Helpers::NumberHelper
    extend ActionView::Helpers::TagHelper
    extend ActionView::Helpers::TranslationHelper

    is_male = candidate[:pohlavi]=="muž"

    font_families['Montserrat'] = {
      :normal => { :file => File.join(Rails.root, 'fonts', 'Montserrat-Regular.ttf') },
      :bold => { :file => File.join(Rails.root, 'fonts', 'Montserrat-Bold.ttf') },
    }
    font 'Montserrat', :size => 10

    width = bounds.width
    line_height = height_of('X')
    vspace = 14

    pad = 20
    width = bounds.width-2*pad
    bounding_box([pad, bounds.height - pad], :width => bounds.width - (pad * 2), :height => bounds.height - (pad * 2)) do

    bounding_box([bounds.width-80,bounds.height+30], width: width) do
      #text("#{candidate.area.election.slug.upcase}/#{candidate.area.slug.upcase}/#{candidate.id}/#{candidate.position}")
    end

    move_down vspace*2


    text("Příloha ke kandidátní listině", align: :center, size: 11)
    move_down vspace
    text(candidates_list[:nazev_volebni_strany], style: :bold, align: :center, size: 11)
    move_down vspace
    text("pro volby do #{genitivize candidates_list[:druh_zastupitelstva]}", align: :center, size: 11)
    move_down vspace
    text(candidates_list[:nazev_zastupitelstva], style: :bold, align: :center, size: 11)
    move_down vspace
    text("konané ve dnech 5. a 6. října 2018", align: :center, size: 11)

    move_down vspace
    text('Prohlášení kandidáta', {
      :size => 16,
      :align => :center
    })
    move_down vspace

    text("Já, níže podepsan#{is_male ? "ý" : "á"} <b>#{cele_jmeno(candidate)}</b>, narozen#{is_male ? "" : "a"} #{l(candidate[:datum_narozeni].to_date)}, trvale bytem #{candidate[:adresa_bydliste]}, prohlašuji, že souhlasím se svou kandidaturou; nejsou mi známy překážky volitelnosti, popřípadě tyto překážky pominou ke dni voleb do #{genitivize candidates_list[:druh_zastupitelstva]}; nedal#{is_male ? "" : "a"} jsem souhlas k tomu abych byl#{is_male ? "" : "a"} uveden#{is_male ? "" : "a"} na jiné kandidátní listině pro volby do téhož zastupitelstva.", inline_format: true)
    move_down vspace*2
    text("V .................................................................... dne ......................................")
    move_down vspace*4
    text("."*50)
    text("Podpis kandidáta")

    move_down vspace

    start_new_page

    image  File.join(Rails.root, 'app', 'assets', 'images', 'Svobodni_logo_RGB.png'), width: 150
    bounding_box([bounds.width-80,bounds.height-340], width: width) do
      #text("#{candidate.area.election.slug.upcase}/#{candidate.area.slug.upcase}/#{candidate.id}/#{candidate.position}")
    end
    move_down vspace*2
    text("Údaje k uvedení na kandidátní listině a interní čestné prohlášení kandidáta", {
      :size => 12,
      :style => :bold,
      :align => :center
    })
    move_down vspace
    text("Jméno a příjmení včetně titulů:   <b>#{cele_jmeno(candidate)}</b>", inline_format: true)
    move_down vspace
    text("Povolání:                                             <b>#{candidate[:povolani]}</b>", inline_format: true)
    move_down vspace
    text("[  ] Prohlašuji, že souhlasím s kandidaturou za Stranu svobodných občanů do zastupitelstva obce a prohlašuji, že souhlasím s těmito principy komunální politiky Svobodných:")
    move_down vspace/2
    indent 20 do

      text("
      Svobodní v komunální politice vychází obecně z těchto principů:
1. Obce hospodaří zpravidla s vyrovnaným rozpočtem a dluhy tvoří jen v mimořádných situacích za souhlasu kvalifikované většiny zastupitelů.
2. Obce vynakládají prostředky na prvním místě na veřejné statky, tj. na obecní silnice, chodníky a zajištění pořádku a čistoty v obcích.
3. Obce svými podnikatelskými aktivitami nemají deformovat tržní prostředí. Primárním smyslem obce není podnikat.
4. Obce ukládají přebytky běžného hospodaření zásadně konzervativně, tj. do aktiv s minimálním rizikem.
5. Obce jsou ve všech aktivitách maximálně transparentní.
6. Obce se nepodílejí na převýchově občanů.
    ", size: 8)
    end
    text("[  ] Čestně prohlašuji, že jsem nespolupracoval#{is_male ? "" : "a"} s StB, že jsem nebyl#{is_male ? " členem" : "a členkou"} Lidových milicí a že nemám záznam v trestním rejstříku.")
    move_down vspace
    text("[  ] Prohlašuji, že jsem byl#{is_male ? " členem" : "a členkou"} těchto politických stran nebo jsem kandidoval#{is_male ? "" : "a"} za tyto politické strany (vyjma Svobodných):"+'.'*170, leading: 10)
move_down vspace
text("Informace a souhlas se zpracováním osobních údajů", align: :center, style: :bold)
move_down vspace
text("  1. Správcem Vašich osobních údajů je Strana svobodných občanů, se sídlem Perucká 2196/14, 120 00 Praha 2, IČ 71339612, dále i Svobodní. Strana svobodných občanů spravuje osobní údaje v souladu s nařízením EU 2016/679 (GDPR).
  2. Za účelem kandidatury ve volbách zpracováváme <b>podle zákona</b> o komunálních volbách č. 491/2001 Sb. § 22 odst. 1, písm d) tyto osobní údaje: <b>jméno a příjmení, adresa, datum narození, pohlaví, politická příslušnost, povolání</b>. Tyto údaje jsou zpracovávány po dobu určenou zákonem a jsou dále předávány těmto zpracovatelům: úřady dle zákona a správce registračního systému KRAXNET s.r.o. IČ 26460335.
  3. Za účelem informovanosti Republikového výboru Svobodných, který dle Pravidel pro výběr kandidátů schvaluje kandidátní listiny, zpracováváme <b>na základě</b> vašeho výslovného <b>souhlasu</b> tyto osobní údaje: <b>členství v politických stranách v minulosti, kandidatura v politických volbách v minulosti, prohlášení o čistém trestním rejstříku, prohlášení o nespolupráci s StB a nečlenství v LM</b>. Tyto údaje zpracováváme po dobu 5 let a předáváme zpracovateli správci registračního systému KRAXNET s.r.o. IČ 26460335.
  4. Můžete vznést námitku proti tomuto zpracování, stejně jako můžete požadovat opravu osobních údajů, požádat o sdělení, jaké osobní údaje o vás evidujeme, případně požádat o výmaz osobních údajů, bude-li to možné. Máte právo na přenositelnost údajů a pokud dochází k automatizovanému zpracování, máte právo nebýt předmětem rozhodnutí založeného výhradně na tomto rozhodování. Souhlas můžete v budoucnu kdykoli odvolat. Se svými žádostmi se můžete obracet na emailem na kancelar@svobodni.cz nebo dopisem na sídlo naší společnosti: Strana svobodných občanů, Perucká 2196/14, 120 00 Praha 2. Můžete také podat stížnost dozorovému úřadu (Úřad na ochranu osobních údajů).
", size: 8, inline_format: true)
text("
  [  ] Souhlasím se zpracováním osobních údajů uvedených v interním čestném prohlášení.
")

    move_down vspace*4

    text("V ....................................................................      dne ......................................      "+
      "podpis: "+"."*50)

   end
 end
end
