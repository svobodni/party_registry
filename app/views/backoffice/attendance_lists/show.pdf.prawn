require "bundler"
Bundler.setup
require "prawn"
require "prawn/table"


prawn_document(:left_margin => 60, :right_margin => 60, :bottom_margin => 25) do |pdf|

  extend ActionView::Helpers::TranslationHelper

  pdf.font_families['Roboto'] = {
    :normal => { :file => File.join(Rails.root, 'fonts', 'Roboto-Regular.ttf') },
    :bold => { :file => File.join(Rails.root, 'fonts', 'Roboto-Bold.ttf') }
  }
  pdf.font 'Roboto', :size => 10

  top = pdf.bounds.top_left[1]
  half_width = pdf.bounds.width / 2
  half_width_column_width = half_width - 5
  vspace = 20
  line_height = pdf.height_of('X')
  logo = "#{Rails.root}/app/assets/images/02_SVOBODNI_logo_tagline.jpg"

  pdf.image logo, :at => [-20, top], :width => 220

  pdf.move_down vspace*5

  pdf.text("Jednání Republikového výboru dne #{l @date} - prezenční listina", { size: 12, color: "00654E" })

  pdf.move_down 20

  pdf.text "Celkem členů ReV <b>#{@members_count}</b> z maximálního možného počtu #{@members_max_count}", inline_format: true

  pdf.text "Nutný počet pro usnášeníschopnost: <b>#{@members_majority}</b>", inline_format: true
  pdf.move_down 20

  data=[
    ["Jméno", "Funkce", "Mandát do", "Podpis"]
  ]+
  @roles.collect{|role|
    org="ReV"
    if role.person.roles.detect{|r| r.body_id!=1 && r.type=="President"}
      org="KrP #{role.person.domestic_region.name}"
    end
    org="ReP" if role.person.roles.detect{|r| r.body_id==1}
    ["#{role.person.last_name} #{role.person.first_name}", org,l(role.till),'']
  }.sort{|a,b| a[0]<=>b[0]}

  pdf.table(data, column_widths: [110, 140, 80, 130]) do
    row(0).font_style = :bold
  end
  pdf.move_down 20

end
