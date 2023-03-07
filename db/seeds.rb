# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


user1 = User.create(name: "John Doe")
user2 = User.create(name: "Sue Jonathan")
user3 = User.create(name: "Alex McDonald")

user1.followers << user2
user2.followers << user3
user3.followers << user1