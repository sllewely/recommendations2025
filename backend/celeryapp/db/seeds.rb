# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'factory_bot'
include FactoryBot::Syntax::Methods

new_users = []
4.times do
  new_users << create(:user)
end

Friendship.create_bidirectional_friendship!(new_users[0], new_users[1])
Friendship.create_bidirectional_friendship!(new_users[0], new_users[2])
Friendship.create_bidirectional_friendship!(new_users[0], new_users[3])
Friendship.create_bidirectional_friendship!(new_users[2], new_users[1])

4.times do
  create(:post, user: new_users[0])
  create(:post, user: new_users[1])
  create(:event, user: new_users[0])
end
