# frozen_string_literal: true

json.extract! user, :id, :name
json.extract! user.profile, :name

json.sgid user.attachable_sgid
json.content render(partial: "mentions/mention", locals: { user: }, formats: [:html])
