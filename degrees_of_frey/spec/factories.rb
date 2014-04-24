FactoryGirl.define do 
  factory :character do 
    sequence(:name) { |n| "Person #{n}"}
    sequence(:page) { |n| "person_#{n}.html"}

  end


end
