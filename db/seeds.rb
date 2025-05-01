User.create!(name: "Example User",
  email: "email@gmail.com",
  password: "password",
  password_confirmation: "password",
  admin: true ,
  activated: true,
  activated_at: Time.zone.now
)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
  )
end
# Tạo microposts cho một nhóm người dùng
users = User.order(:created_at).take(6)

50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end

# Tạo quan hệ following/followers mẫu
users     = User.all
user      = users.first               # User đầu tiên (Example User)
following = users[2..50]              # Các user thứ 3–51
followers = users[3..40]              # Các user thứ 4–41

# User đầu tiên theo dõi users 3→51
following.each { |followed| user.follow(followed) }

# Users 4→41 theo dõi lại user đầu tiên
followers.each { |follower| follower.follow(user) }




