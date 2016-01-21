FactoryGirl.define do
    factory :pet do
        name 'simple pet'
        caption 'simple caption about pet'
        association :user

        trait :invalid do
            name nil
            caption nil
        end
    end
end
