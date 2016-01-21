FactoryGirl.define do
    factory :comment do
        body 'simple comment'
        association :user
        association :pet

        trait :invalid do
            body nil
        end
    end
end
