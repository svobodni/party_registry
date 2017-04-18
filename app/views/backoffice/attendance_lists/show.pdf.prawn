require "bundler"
Bundler.setup
require "prawn"
require "prawn/table"


prawn_document(:left_margin => 60, :right_margin => 60, :bottom_margin => 100) do |pdf|

  extend ActionView::Helpers::TranslationHelper

  pdf.font_families['Montserrat'] = {
    :normal => { :file => File.join(Rails.root, 'fonts', 'Montserrat-Regular.ttf') },
    :bold => { :file => File.join(Rails.root, 'fonts', 'Montserrat-Bold.ttf') }
  }
  pdf.font 'Montserrat', :size => 10

  top = pdf.bounds.top_left[1]
  half_width = pdf.bounds.width / 2
  half_width_column_width = half_width - 5
  vspace = 20
  line_height = pdf.height_of('X')
  logo = "#{Rails.root}/app/assets/images/Svobodni_logo_CMYK.png"

  pdf.repeat(:all) do
    pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], :width  => pdf.bounds.width do
      pdf.image logo, :width => 220, :at => [0, 0]
      pdf.move_down vspace*5
      pdf.text("Jednání Republikového výboru dne #{l @date} - prezenční listina", { size: 12, color: "009681" })
    end
  end

  pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 130], :width  => pdf.bounds.width, :height => pdf.bounds.height - 100) do
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
    }.sort{|a,b| @collator.compare(a[0], b[0])}

    pdf.table(data, column_widths: [110, 140, 80, 130]) do
      row(0).font_style = :bold
    end
    #pdf.move_down 20
    pdf.number_pages "<page>/<total>", {color: "009681", align: :right, size: 8, at: [pdf.bounds.right - 50, -10]}
  end
end
