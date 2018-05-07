class DeclarationPdf < Prawn::Document
  def initialize(candidate, candidates_list)
    super()

    extend ActionView::Helpers::NumberHelper
    extend ActionView::Helpers::TagHelper
    extend ActionView::Helpers::TranslationHelper

    is_male = candidate[:pohlavi]=="muž"

    font_families['Montserrat'] = {
      :normal => { :file => File.join(Rails.root, 'fonts', 'Montserrat-Regular.ttf') },
    }
    font 'Montserrat', :size => 10

    width = bounds.width
    line_height = height_of('X')
    vspace = 15

    pad = 20
    width = bounds.width-2*pad
    bounding_box([pad, bounds.height - pad], :width => bounds.width - (pad * 2), :height => bounds.height - (pad * 2)) do

    bounding_box([bounds.width-80,bounds.height+30], width: width) do
      #text("#{candidate.area.election.slug.upcase}/#{candidate.area.slug.upcase}/#{candidate.id}/#{candidate.position}")
    end

    move_down vspace*2

    text("Příloha ke kandidátní listině pro volby do #{candidates_list[:druh_zastupitelstva]} #{candidates_list[:nazev_zastupitelstva]} konané ve dnech ..... ")

    move_down vspace
    text('Prohlášení kandidáta', {
      :size => 24,
      :styles => [:bold],
      :align => :center
    })
    move_down vspace

    text("Já, níže podepsan#{is_male ? "ý" : "á"} #{candidate[:jmeno]} #{candidate[:prijmeni]}, narozen#{is_male ? "" : "a"} #{l(candidate[:datum_narozeni].to_date)}, trvale bytem #{candidate[:adresa_bydliste]}, prohlašuji, že souhlasím se svou kandidaturou; nejsou mi známy překážky volitelnosti; nedal jsem souhlas k tomu abych byl#{is_male ? "" : "a"} uvenden#{is_male ? "" : "a"} na jiné kandidátní listině pro volby do téhož zastupitelstva.")
    move_down vspace
    text("V .................................................................... dne ......................................")
    move_down vspace*2
    text("."*50)
    text("Podpis kandidáta")

    move_down vspace

    text("--------------------------------------------------------------------------------------------------------------------------------------")
    move_down vspace
    image  File.join(Rails.root, 'app', 'assets', 'images', 'Svobodni_logo_RGB.png'), width: 150
    bounding_box([bounds.width-80,bounds.height-340], width: width) do
      #text("#{candidate.area.election.slug.upcase}/#{candidate.area.slug.upcase}/#{candidate.id}/#{candidate.position}")
    end
    move_down vspace
    text("Údaje k uvedení na kandidátní listině a interní čestné prohlášení", {
      :size => 12,
      :styles => [:bold],
      :align => :center
    })
    move_down vspace*2
    text("Jméno a příjmení včetně titulů:   "+'.'*160)
    move_down vspace
    text("Povolání:\t\t\t\t"+'.'*160)
    move_down vspace
    text("Prohlašuji, že souhlasím s kandidaturou za Stranu svobodných občanů do zastupitelstva obce a že souhasím se zásadami komunální politiky Svobodných *)")
    move_down vspace
    text("Čestně prohlašuji, že jsem nespolupracoval s StB, že jsem nebyl členem Lidových milicí a že nemám záznam v trestním rejstříku.")
    move_down vspace
    text("Prohlašuji, že jsem byl členem těchto politických stran nebo jsem kandidoval za tyto politické strany (vyjma Svobodných):")
    move_down vspace
    text("
      *) Svobodní v komunální politice vychází obecně z těchto principů:
1. Obce hospodaří zpravidla s vyrovnaným rozpočtem a dluhy tvoří jen v mimořádných situacích za souhlasu kvalifikované většiny zastupitelů.
2. Obce vynakládají prostředky na prvním místě na veřejné statky, tj. na obecní silnice, chodníky a zajištění pořádku a čistoty v obcích.
3. Obce svými podnikatelskými aktivitami nesmí deformovat tržní prostředí. Primárním smyslem obce není podnikat.
4. Obce ukládají přebytky běžného hospodaření zásadně konzervativně, tj. do aktiv s minimálním rizikem.
5. Obce jsou ve všech aktivitách maximálně transparentní.
6. Obce se nepodílejí na převýchově občanů.
    ", size: 8)
    # move_right(20)
    text(' '*40+'.'*180)
    move_down vspace
    text("V .................................................................... dne ......................................")
    move_down vspace*2
    text("."*50)
    text("Podpis kandidáta")

   end
 end
end
