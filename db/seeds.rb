# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create({ username: 'admin', password: 'password', admin: true })
Category.create({ name: 'Featured' })
Category.create({ name: 'Popular' })
Category.create({ name: 'Education' })
Category.create({ name: 'Campus Life' })
Category.create({ name: 'Community' })
Site.create({ title: 'Example site' })
