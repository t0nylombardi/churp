# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Faker::Config.locale = 'en'

Tweet.destroy_all
User.destroy_all
Profile.destroy_all

# Create users
0.upto(10) do |_i|
  role = %i[admin basic].sample
  user = User.create(
    email: Faker::Internet.email,
    password: 'Passw0rd1!',
    password_confirmation: 'Passw0rd1!',
    username: "@#{Faker::Internet.username(specifier: 8)}",
    role:
  )
  user.save!

  user.create_profile(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    description: Faker::Lorem.sentence(word_count: 20),
    website: "https://#{Faker::Internet.domain_name}",
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 65)
  )
  puts "Created user: #{user.email}"
end

100.times do
  tweet = Tweet.create(
    body: Faker::Lorem.sentence(word_count: 3),
    user_id: User.all.sample.id
  )
  25.times do
    tweet.comments.create(
      content: Faker::Lorem.sentence(word_count: 20),
      user_id: User.all.sample.id
    )
  end
  puts "Created tweet: #{tweet.id}"
end
