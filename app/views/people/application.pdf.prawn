pdf.move_down 20
pdf.table([
		[{ colspan: 2, content: "Variabilní symbol: 11176", align: :right}],
		[{ colspan: 2, content: "Přihláška do Strany svobodných občanů", size: 17, font_style: :bold}],
		["Jméno", @person.name],
		["Ulice", "lorem ipsum"],
		["Obec","lorem ipsum"],
		["PSČ","lorem ipsum"],
		["Kraj", @person.domestic_region.try(:name)],
		["Datum narození","lorem ipsum"],
		["Telefon","lorem ipsum"],
		["Email","lorem ipsum"],
		[{ colspan: 2, content: "Dřívější členství v politických stranách"}],
		[{ colspan: 2, content: ""}],
		[{ colspan: 2, content: "Dřívější kandidatury ve volbách"}],
		[{ colspan: 2, content: ""}],
		[{ colspan: 2, content: "Prohlašuji, že nejsem členem jiné politické strany, že souhlasím se stanovami, programovým prohlášením, že jsem nebyl členem Lidových milicí ani spolupracovníkem či agentem STB, že všechny uvedené údaje jsou pravdivé a že souhlasím se zpracováním a správou uvedených údajů Stranou svobodných občanů"}],
		["31.1.2014","Podpis:"]], position: :center, column_widths: [100, 300])
pdf.move_down 20
pdf.text "Podepsanou přihlášku zašlete prosím na adresu:"
pdf.text "Krajské sdružení Svobodných Karlovarský kraj"
pdf.text "Lázeňská 11"
pdf.text "36001 Karlovy Vary"