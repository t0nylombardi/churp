# frozen_string_literal: true

module AttachmentHelper
  def attach(record, name, filename, content_type)
    record.public_send(name).attach(
      io: Rails.root.join("spec/fixtures/images/#{filename}").open,
      filename: filename,
      content_type: content_type
    )
  end
end
