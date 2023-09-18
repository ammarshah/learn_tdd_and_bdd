FactoryBot.define do

  factory :invitation do
    user
    team
  end

  factory :user do
    email { "john@example.com" }
    invited { false }
    team
  end

  factory :team do
    name { "Backend Devs" }
  end

  factory :magazine do
    name { "The Ruby Times" }
  end

  factory :person do
  end

  factory :subscription do
    person
    magazine
  end

end
