# frozen_string_literal: true

# config/initializers/disable_actiontext_annotations.rb

# Monkey-patch ActionText::ContentHelper to disable view annotation comments
# during attachment rendering. Prevents HTML comments like:
# <!-- BEGIN app/views/users/_user.html.erb --> from being persisted in rich text.

module ActionText
  module DisableAnnotationsPatch
    def render_attachment(attachment, **options)
      previous = ActionView::Base.annotate_rendered_view_with_filenames
      ActionView::Base.annotate_rendered_view_with_filenames = false

      html = super
      html.gsub(/<!-- BEGIN.*?-->|<!-- END.*?-->/m, "").html_safe
    ensure
      ActionView::Base.annotate_rendered_view_with_filenames = previous
    end
  end
end

Rails.application.config.to_prepare do
  ActionText::ContentHelper.prepend(ActionText::DisableAnnotationsPatch)
end
