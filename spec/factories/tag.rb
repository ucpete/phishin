# frozen_string_literal: true
FactoryBot.define do
  factory :tag do
    name { "Tag #{Faker::Book.unique.title}"[0..40] }
    color { Faker::Color.hex_color }
    description { Faker::Lorem.sentence }
    sequence(:priority)

    trait :with_tracks do
      tracks { build_list(:track, 2) }
    end

    trait :with_shows do
      shows { build_list(:show, 2) }
    end
  end
end
