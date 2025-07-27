module ApplicationHelper
  def rhino_editor_for(form, field = :content, options = {})
    css_class = options[:class] || "w-full min-w-full h-full prose prose-xl text-black"
    heading_level = options[:heading_level] || 2

    field_id = options[:id] || form.field_id(field)
    field_value = form.object.send(field).try(:to_trix_html) || form.object.send(field)

    content_tag(:div) do
      concat form.hidden_field(field, id: field_id, value: field_value)
      concat content_tag(
        "rhino-editor",
        "",
        input: field_id,
        "data-blob-url-template": rails_service_blob_url(":signed_id", ":filename"),
        "data-direct-upload-url": rails_direct_uploads_url,
        "default-heading-level": heading_level,
        class: css_class
      )
    end
  end
end
