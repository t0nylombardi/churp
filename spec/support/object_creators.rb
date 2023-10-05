module ObjectCreators

  def create_user(params = {})
    last_id = User.limit(1).order(id: :desc).pluck(:id).first || 0
    user = User.new(
      email: params[:name].present? ? "#{params[:name]}@test.com" : "testtest#{last_id + 1}@test.com",
      username: params[:name].present? ? params[:name].to_s : "testtest#{last_id + 1}",
      password: 'testtest',
      password_confirmation: 'testtest'
    )
    user.skip_confirmation!
    user.save!
    user
  end
end
