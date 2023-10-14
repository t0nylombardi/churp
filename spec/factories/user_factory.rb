FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'Passw0rd1!' }
    password_confirmation { 'Passw0rd1!' }
    username { "@#{Faker::Internet.username(specifier: 8)}" }

    after(:create) do |user|
      user.profile ||= create(:profile, user:)
    end
  end

  trait :admin do
    role { 'admin' }
  end
end
