module ProfilesHelper

  def progress_bar
    content_tag(:ul, class: "nav nav-tabs") do
      wizard_steps.collect do |every_step|
        concat(
        content_tag(:li, class: (current_page?(id: every_step) ? "active" : "")) do
          link_to I18n.t(every_step), wizard_path(every_step)
        end
        )
      end
    end
  end

end
