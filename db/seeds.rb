# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# admin
user = User.create!(
  email: 'admin@admin.com',
  password: 'Passw0rd1!',
  password_confirmation: 'Passw0rd1!',
  role: 'admin'
)

0.upto(10) do |_i|
  user = User.create!(
    email: Faker::Internet.email,
    password: 'Passw0rd1!',
    password_confirmation: 'Passw0rd1!'
  )

  user.tweets.create!(
    body: Faker::Lorem.sentence(word_count: 3,
                                supplemental: false,
                                random_words_to_add: 4)
  )
end
