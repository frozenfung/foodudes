# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#建立第一筆推薦from pong
r0 = Restaurant.new
r0.name = '阿妹麵店'
r0.address = '台北市中正區南昌路二段105號'
r0.lng = 121.5215058
r0.lat = 25.026681

r1 = Restaurant.new
r1.name = 'WilBeck'
r1.address = '台北市中正區南昌路二段105號'
r1.lng = 121.52272199999993
r1.lat = 25.0263958

u = User.where(:fb_uid => '973493649331051').first
ur = u.user_restaurants.new
ur.restaurant = r0
ur.comment = '便宜實惠'
ur.dish = '魷魚羹意麵'
ur.notice = '中午人很多要排隊'
ur.save

u = User.where(:fb_uid => '973493649331051').first
ur = u.user_restaurants.new
ur.restaurant = r1
ur.comment = '便宜實惠'
ur.dish = '魷魚羹意麵'
ur.notice = '中午人很多要排隊'
ur.save










