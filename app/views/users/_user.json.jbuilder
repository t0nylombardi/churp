json.username user.username
json.name user.profile.name
json.profile_pic Rails.application.routes.url_helpers.url_for user.profile.profile_pic
json.sgid user.attachable_sgid
json.content render(partial: 'users/user', locals: { user: }, formats: [:html])

