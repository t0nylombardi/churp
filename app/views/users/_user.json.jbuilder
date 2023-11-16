json.username user.username
json.name user.profile.name
json.profile_pic user.profile.profile_pic.url
json.sgid user.attachable_sgid
json.content render(partial: 'users/user', locals: { user: user }, formats: [:html])

