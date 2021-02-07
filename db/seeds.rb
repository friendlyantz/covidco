# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'httparty'
require 'open-uri'

locations_limit = 5
puts "locations_limit: #{locations_limit}"
restaurants_seed_limit = 30
puts "restaurants_seed_limit: #{restaurants_seed_limit}"
parks_seed_limit = 30
puts "parks_seed_limit: #{parks_seed_limit}"
photos_via_api_limit = 5
puts "photos_via_api_limit: #{photos_via_api_limit}"

image_width = "400"
puts "API image width set to: #{image_width}"

API_KEY = ENV["GOOGLE_API_KEY"]

puts "Erasing old records..."

# Tag.destroy_all
# Tagging.destroy_all
Vote.destroy_all
Review.destroy_all
Bookmark.destroy_all

  Location.all.each do |location|
    location.photo.purge
  end

  Place.all.each do |place|
    place.photos.purge
  end

puts "Location and Places photos purged"
Location.destroy_all
Place.destroy_all
User.destroy_all

# ============ LOCATIONS =============
puts "..................."
puts "Creating locations..."
  cities = [
    { name: "Austin", state: "Texas" },
    { name: "Atlanta", state: "Georgia" },
    { name: "New York", state: "New York" },
    { name: "Los Angeles", state: "California" },
    { name: "Chicago", state: "Illinois" },
    { name: "Houston", state: "Texas" },
    { name: "Phoenix",  state: "Arizona" }
  ]

  cities.each_with_index do |city, city_index|
			created_city = Location.create(city: city[:name], state: city[:state])
      # Active Storage photo
      puts "#{created_city.city} created. uploading photo..."
				created_city.photo.attach(
						io: File.open('app/assets/images/cities/Austin.jpg'),
						filename: "Austin#{city_index+1}.jpg",
						content_type: 'image/jpg'
						)
			puts "Photo attached for #{created_city.city}?: #{created_city.photo.attached?}"
      if city_index == locations_limit - 1
        "limit HIT======"
        break
      end
  end


  # Location.create(city: Faker::Address.unique.city)
puts "==> Done. Now we have #{Location.all.count} location(s)"


# ============ USERS =============
puts "..................."
puts "Creating users..."
# TEST USERS
User.create(email: "test@test.com", password: "password", first_name: "Testosteron", last_name: "Testovich", location: Location.second )
puts "test login user created: test@test.com, password: 'password' - his name is Testosteron Testovich :)"
# TEST TEAM
test_team = [ ['Amani', 'amanianai'], ['Rachel', 'rycmak'], ['Anton', 'friendlyantz'], ['Jody', 'JodyVanden'], ['Caio', 'caioertai'], ['Sheila', 'sheesh19'], ['Sy', 'syrashid'], ]
test_team.each do |user_details|
  user = User.create(email: "#{user_details[0]}@cc.com", password: "password", first_name: user_details[0], last_name: user_details[1], location: Location.first)
  puts "----> #{user.email} account created!"
end

honorary_users = [{ first_name: "Sandra", last_name: "Bullock" },
                  { first_name: "Richard", last_name: "Linklater"} ]

honorary_users.each do |user|
  first_name = user[:first_name]
  last_name = user[:last_name]
  User.create(first_name: first_name, last_name: last_name, email: "#{first_name}.#{last_name}@cc.com", password: "password", location: Location.first)
  puts "-> User: #{first_name} #{last_name} created"
end

puts "==> Done! Now we have #{User.all.count} user(s)."

# ============ PLACES =============

# All places are seeded with a default tag_list.  This method modifies the list as appropriate to the restaurant.
  def modify_default_tag_list_restaurant(add_tags, remove_tags)
    default_tag_list = ["Outdoor seating", "Dine-in", "Curbside pickup", "Takeaway", "Mask required", "Surfaces disinfected"]
    tag_list = default_tag_list
    add_tags.each do |tag|
      tag_list << tag
    end
    remove_tags.each do |tag|
      tag_list.delete(tag)
    end
    return tag_list
  end

# From Google Places API:
restaurants_array = [
  {:name=>"Contigo", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"2027 Anchor Ln, Austin, TX 78723, USA", :latitude=>30.28789849999999, :longitude=>-97.70340499999999, :business_hours=>["Monday: 4:00 – 9:00 PM", "Tuesday: 4:00 – 9:00 PM", "Wednesday: 4:00 – 9:00 PM", "Thursday: 4:00 – 9:00 PM", "Friday: 4:00 – 10:00 PM", "Saturday: 4:00 – 10:00 PM", "Sunday: 4:00 – 9:00 PM"], :price=>2, :description=>"Farm-fresh Texas fare meets seasonal cocktails & beer, plus a large all-weather patio.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Casual", "Cosy", "Upmarket", "Groups", "Kids", "Comfort food", "Vegetarian options", "Healthy options", "Happy hour"], []), :website=>"http://contigotexas.com/", :rating=>4.3, :phone=>"(512) 614-2260" },
  {:name=>"Suerte", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"1800 E 6th St, Austin, TX 78702, USA", :latitude=>30.2622778, :longitude=>-97.7232758, :business_hours=>["Monday: 4:00 – 9:30 PM", "Tuesday: 4:00 – 9:30 PM", "Wednesday: 4:00 – 9:30 PM", "Thursday: 4:00 – 10:00 PM", "Friday: 4:00 – 10:00 PM", "Saturday: 11:00 AM – 10:00 PM", "Sunday: 11:00 AM – 9:30 PM"], :price=>3, :description=>"Contemporary spot serving interior Mexican specialties & snacks, beer, wine & craft cocktails.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Bar", "Delivery", "Casual", "Cosy", "Romantic", "Upmarket", "Happy hour", "Families", "Groups", "Kids", "Comfort food", "Vegetarian options", "Healthy options"], []), :website=>"https://www.suerteatx.com/", :rating=>4.6, :phone=>"(512) 953-0092" },
  {:name=>"Loro", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"2115 S Lamar Blvd, Austin, TX 78704, USA", :latitude=>30.24778989999999, :longitude=>-97.771277, :business_hours=>["Monday: 11:30 AM – 10:00 PM", "Tuesday: 11:30 AM – 10:00 PM", "Wednesday: 11:30 AM – 10:00 PM", "Thursday: 11:30 AM – 10:00 PM", "Friday: 11:30 AM – 11:00 PM", "Saturday: 11:30 AM – 11:00 PM", "Sunday: 11:30 AM – 10:00 PM"], :price=>3, :description=>"Asian smokehouse meets Texas barbecue in rustic spot with beer, wine & cocktails plus giant patio.", :category=>"Nightlife", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Bar", "Casual", "Delivery", "Happy hour", "Families", "Groups", "Comfort food"], []), :website=>"http://loroaustin.com/", :rating=>4.6, :phone=>"(512) 916-4858" },
  {:name=>"Sour Duck Market", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"1814 E Martin Luther King Jr Blvd, Austin, TX 78702, USA", :latitude=>30.280047, :longitude=>-97.7215188, :business_hours=>["Monday: Closed", "Tuesday: Closed", "Wednesday: 10:00 AM – 8:00 PM", "Thursday: 10:00 AM – 8:00 PM", "Friday: 10:00 AM – 8:00 PM", "Saturday: 10:00 AM – 8:00 PM", "Sunday: 10:00 AM – 8:00 PM"], :price=>2, :description=>"Casual restaurant serving American fare made from locally-sourced ingredients plus market & bar.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Bar", "Delivery", "Casual", "Cosy", "Kids", "Families", "Groups", "Happy hour", "Comfort food", "Vegetarian options", "Healthy options", "Quick bite"], []), :website=>"http://sourduckmarket.com/", :rating=>4.5, :phone=>"(512) 394-5776" },
  {:name=>"Home Slice Pizza", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"1415 S Congress Ave, Austin, TX 78704, USA", :latitude=>30.249222, :longitude=>-97.749518, :business_hours=>["Monday: 11:00 AM – 10:00 PM", "Tuesday: 11:00 AM – 10:00 PM", "Wednesday: 11:00 AM – 10:00 PM", "Thursday: 11:00 AM – 10:00 PM", "Friday: 11:00 AM – 11:00 PM", "Saturday: 11:00 AM – 11:00 PM", "Sunday: 11:00 AM – 10:00 PM"], :price=>2, :description=>"Thin-crust slices & pies for dining in or carry out, open late for takeaway on weekends.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Bar", "Casual", "Cosy", "Groups", "Kids", "Open late", "Comfort food", "Vegetarian options", "Quick bite"], []), :website=>"http://www.homeslicepizza.com/", :rating=>4.7, :phone=>"(512) 444-7437" },
  {:name=>"Bufalina Pizza", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"1519 E Cesar Chavez St #200, Austin, TX 78702, USA", :latitude=>30.258394, :longitude=>-97.728867, :business_hours=>["Monday: Closed", "Tuesday: Closed", "Wednesday: 11:00 AM – 11:00 PM", "Thursday: 11:00 AM – 11:00 PM", "Friday: 11:00 AM – 11:00 PM", "Saturday: 11:00 AM – 11:00 PM", "Sunday: 11:00 AM – 11:00 PM"], :price=>2, :description=>"Handcrafted Neapolitan pies with artisanal ingredients join beer & wine in a cool space.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Casual", "Cosy", "Groups", "Comfort food", "Vegetarian options"], ["Outdoor seating", "Dine-in"]), :website=>"http://www.bufalinapizza.com/", :rating=>4.6, :phone=>"(512) 524-2523" },
  {:name=>"Flower Child", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"500 W 2nd St Suite 133, Austin, TX 78701, USA", :latitude=>30.26603609999999, :longitude=>-97.74965279999999, :business_hours=>["Monday: 11:00 AM – 9:00 PM", "Tuesday: 11:00 AM – 9:00 PM", "Wednesday: 11:00 AM – 9:00 PM", "Thursday: 11:00 AM – 9:00 PM", "Friday: 11:00 AM – 9:00 PM", "Saturday: 11:00 AM – 9:00 PM", "Sunday: 11:00 AM – 9:00 PM"], :price=>2, :description=>"Health-oriented, bohemian cafe for custom salads, grain bowls & soups with additive-free proteins.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Delivery", "Casual", "Staff temperature checks", "Healthy options", "Kids", "Families", "Groups", "Quick bite"], []), :website=>"http://www.iamaflowerchild.com/nso/austin-2nd-street/", :rating=>4.6, :phone=>"(512) 777-4132" },
  {:name=>"Nixta Taqueria", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"2512 E 12th St, Austin, TX 78702, USA", :latitude=>30.2750063, :longitude=>-97.71326380000001, :business_hours=>["Monday: Closed", "Tuesday: 12:00 – 8:00 PM", "Wednesday: 12:00 – 8:00 PM", "Thursday: 12:00 – 8:00 PM", "Friday: 12:00 – 9:00 PM", "Saturday: 12:00 – 9:00 PM", "Sunday: 11:00 AM – 3:00 PM"], :price=>2, :description=>"Open for dine-in and curbside takeout. If you know, you know. Chef Rico is bringing tacos, tostadas, paletas and aguas frescas to the E. 12th and Austin community. We're using heirloom corn to make some dope tortillas on the daily.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Bar", "Casual", "Cosy", "Happy hour", "Vegetarian options", "Healthy options", "Organic dishes", "Families", "Kids", "Quick bite"], []), :website=>"http://www.nixtataqueria.com/", :rating=>4.7, :phone=>"(512) 551-3855" },
  {:name=>"Paperboy", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"1203 E 11th St, Austin, TX 78702, USA", :latitude=>30.2684012, :longitude=>-97.72759049999999, :business_hours=>["Monday: 8:00 AM – 3:00 PM", "Tuesday: 8:00 AM – 3:00 PM", "Wednesday: 8:00 AM – 3:00 PM", "Thursday: 8:00 AM – 3:00 PM", "Friday: 8:00 AM – 3:00 PM", "Saturday: 8:00 AM – 3:00 PM", "Sunday: 8:00 AM – 3:00 PM"], :price=>2, :description=>"Stationary trailer with a patio serving seasonal breakfast sandwiches, bowls, toasts & coffee.", :category=>"Food and Drink", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Bar", "Casual", "Families", "Groups", "Comfort food", "Vegetarian options", "Healthy options", "Quick bite"], ["Curbside pickup"]), :website=>"http://www.paperboyaustin.com/", :rating=>4.7, :phone=>"(512) 910-3010" },
  {:name=>"Via 313 Pizza", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"1802 E 6th St, Austin, TX 78702, USA", :latitude=>30.2620881, :longitude=>-97.72312269999999, :business_hours=>["Monday: 11:00 AM – 9:00 PM", "Tuesday: 11:00 AM – 9:00 PM", "Wednesday: 11:00 AM – 9:00 PM", "Thursday: 11:00 AM – 9:00 PM", "Friday: 11:00 AM – 10:00 PM", "Saturday: 11:00 AM – 10:00 PM", "Sunday: 11:00 AM – 9:00 PM"], :price=>2, :description=>"The pizza at Via 313 is inspired by our memories of traditional Detroit-Style pies from our youths (Cloverleaf, Buddy’s, Loui’s, Niki’s) and the best traditional pizzas in the region. If you're new to Detroit Style Pizza, stop by and let us show you what it's all about.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Bar", "Staff temperature checks", "Casual", "Kids", "Families", "Groups", "Comfort food", "Vegetarian options"], ["Dine-in"]), :website=>"http://www.via313.com/", :rating=>4.7, :phone=>"(512) 358-6193" },
  {:name=>"The Austin Beer Garden Brewing Co", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"1305 W Oltorf St, Austin, TX 78704, USA", :latitude=>30.24538690000001, :longitude=>-97.7688519, :business_hours=>["Monday: Closed", "Tuesday: 11:30 AM – 11:00 PM", "Wednesday: 11:30 AM – 11:00 PM", "Thursday: 11:30 AM – 11:00 PM", "Friday: 11:30 AM – 11:00 PM", "Saturday: 12:00 PM – 12:00 AM", "Sunday: 12:00 – 10:00 PM"], :price=>2, :description=>"Warehouselike beer garden matching house microbrews with pub bites such as pizza & sandwiches.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Bar", "Casual", "Organic dishes"], []), :website=>"http://www.theabgb.com/", :rating=>4.6, :phone=>"(512) 298-2242" },
  {:name=>"Ramen Tatsu-Ya", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"1234 S Lamar Blvd, Austin, TX 78704, USA", :latitude=>30.2539227, :longitude=>-97.76326639999999, :business_hours=>["Monday: 11:00 AM – 10:00 PM", "Tuesday: 11:00 AM – 10:00 PM", "Wednesday: 11:00 AM – 10:00 PM", "Thursday: 11:00 AM – 10:00 PM", "Friday: 11:00 AM – 10:00 PM", "Saturday: 11:00 AM – 10:00 PM", "Sunday: 11:00 AM – 10:00 PM"], :price=>2, :description=>"Popular noodle house & bar with a funky vibe serving classic ramen with many options for topping.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Casual", "Cosy", "Groups", "Comfort food", "Vegetarian options", "Healthy options", "Happy hour"], ["Outdoor seating", "Dine-in", "Curbside pickup", "Surfaces disinfected"]), :website=>"http://ramen-tatsuya.com/", :rating=>4.7, :phone=>"(512) 893-5561" },
  {:name=>"Little Deli & Pizzeria", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"7101 Woodrow Ave Unit A, Austin, TX 78757, USA", :latitude=>30.34257849999999, :longitude=>-97.7254682, :business_hours=>["Monday: 11:00 AM – 9:00 PM", "Tuesday: 11:00 AM – 9:00 PM", "Wednesday: 11:00 AM – 9:00 PM", "Thursday: 11:00 AM – 9:00 PM", "Friday: 11:00 AM – 9:00 PM", "Saturday: 11:00 AM – 9:00 PM", "Sunday: Closed"], :price=>1, :description=>"Small, deli-style storefront supplies Jersey-style specialty pizzas plus hot & cold sandwiches.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Casual", "Cosy", "Groups", "Kids", "Comfort food", "Vegetarian options", "Quick bite"], []), :website=>"https://littledeliandpizza.com/", :rating=>4.8, :phone=>"(512) 467-7402" },
  {:name=>"Fareground", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"111 Congress Ave p400, Austin, TX 78701, USA", :latitude=>30.263562, :longitude=>-97.743534, :business_hours=>["Monday: 8:00 AM – 10:00 PM", "Tuesday: 8:00 AM – 10:00 PM", "Wednesday: 8:00 AM – 10:00 PM", "Thursday: 8:00 AM – 10:00 PM", "Friday: 8:00 AM – 10:00 PM", "Saturday: 11:00 AM – 10:00 PM", "Sunday: 11:00 AM – 10:00 PM"], :price=>nil, :description=>"Counter with farm-to-table burgers, rotisserie chicken, wings & salad plus breakfast options.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Delivery"], ["Outdoor seating", "Dine-in", "Curbside pickup", "Mask required", "Surfaces disinfected"]), :website=>"http://faregroundaustin.com/", :rating=>4.4,  },
  #{:name=>"Fresa's 9th & Lamar", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"915 N Lamar Blvd, Austin, TX 78703, USA", :latitude=>30.27444439999999, :longitude=>-97.75222219999999, :business_hours=>["Monday: 8:00 AM – 10:00 PM", "Tuesday: 8:00 AM – 10:00 PM", "Wednesday: 8:00 AM – 10:00 PM", "Thursday: 8:00 AM – 10:00 PM", "Friday: 8:00 AM – 10:00 PM", "Saturday: 8:00 AM – 10:00 PM", "Sunday: 8:00 AM – 10:00 PM"], :price=>2, :description=>"Drive-thru & walk-up window dispensing wood-grilled chicken, modern Mexican eats & ice cream.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Staff temperature checks", "Casual", "Comfort food", "Healthy options", "Quick bite"], ["Outdoor seating", "Dine-in", "Curbside pickup"]), :website=>"http://www.fresaschicken.com/", :rating=>4.2, :phone=>"(512) 428-5077" },
  {:name=>"Salt & Time Butcher Shop and Restaurant", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"1912 E 7th St, Austin, TX 78702, USA", :latitude=>30.2626481, :longitude=>-97.7210695, :business_hours=>["Monday: 10:00 AM – 8:00 PM", "Tuesday: 10:00 AM – 8:00 PM", "Wednesday: 10:00 AM – 8:00 PM", "Thursday: 10:00 AM – 8:00 PM", "Friday: 10:00 AM – 8:00 PM", "Saturday: 10:00 AM – 8:00 PM", "Sunday: 10:00 AM – 8:00 PM"], :price=>2, :description=>"Rustic-cool eatery in a butcher shop serving meat-centric farm-to-table American fare, beer & wine.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Staff temperature checks", "Quick bite"], ["Outdoor seating", "Dine-in", "Curbside pickup"]), :website=>"http://www.saltandtime.com/", :rating=>4.5, :phone=>"(512) 524-1383" },
  {:name=>"Aba Austin", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"1011 S Congress Ave, Austin, TX 78704, USA", :latitude=>30.2534769, :longitude=>-97.74788769999999, :business_hours=>["Monday: 11:00 AM – 11:00 PM", "Tuesday: 11:00 AM – 11:00 PM", "Wednesday: 11:00 AM – 11:00 PM", "Thursday: 11:00 AM – 11:00 PM", "Friday: 11:00 AM – 12:00 AM", "Saturday: 10:00 AM – 12:00 AM", "Sunday: 10:00 AM – 9:00 PM"], :price=>nil, :description=>"Aba is a Mediterranean restaurant originating from Chicago’s historic Fulton Market District. Aba, meaning father in Hebrew, incorporates Chef CJ Jacobson's lighter style of cooking with influences from the Mediterranean, including Israel, Lebanon, Turkey, and Greece. The bar program, crafted by Liz Pearce, showcases rare Mediterranean-inspired wines and spirits.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Bar", "Delivery", "Casual", "Staff temperature checks", "Comfort food", "Vegetarian options", "Kids"], []), :website=>"https://www.abarestaurants.com/austin/", :rating=>4.7, :phone=>"(737) 273-0199" },
  {:name=>"Clark's Oyster Bar", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"1200 W 6th St, Austin, TX 78703, USA", :latitude=>30.2729938, :longitude=>-97.7571715, :business_hours=>["Monday: 11:00 AM – 10:00 PM", "Tuesday: 11:00 AM – 10:00 PM", "Wednesday: 11:00 AM – 10:00 PM", "Thursday: 11:00 AM – 10:00 PM", "Friday: 11:00 AM – 10:00 PM", "Saturday: 11:00 AM – 10:00 PM", "Sunday: 11:00 AM – 10:00 PM"], :price=>3, :description=>"Upscale-casual seafood spot with an open kitchen, marble-topped bar, plus indoor & outdoor seating.", :category=>"Drinks", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Casual", "Cosy", "Romantic", "Upmarket", "Happy hour", "Healthy options"], []), :website=>"http://clarksoysterbar.com/", :rating=>4.5, :phone=>"(512) 297-2525" },
  {:name=>"Little Ola's Biscuits (Olamaie)", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"1610 San Antonio St, Austin, TX 78701, USA", :latitude=>30.2799058, :longitude=>-97.7436953, :business_hours=>["Monday: Closed", "Tuesday: Closed", "Wednesday: Closed", "Thursday: 10:00 AM – 8:00 PM", "Friday: 10:00 AM – 8:00 PM", "Saturday: 10:00 AM – 8:00 PM", "Sunday: 10:00 AM – 8:00 PM"], :price=>3, :description=>"Southern fare is elevated with farm-fresh ingredients & modern plating in elegant refurbished home.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Bar", "Casual", "Cosy", "Romantic", "Upmarket", "Comfort food", "Healthy options"], ["Outdoor seating", "Dine-in"]), :website=>"http://olamaieaustin.com/", :rating=>4.5, :phone=>"(512) 474-2796" },
  {:name=>"Uchiko", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"4200 N Lamar Blvd, Austin, TX 78756, USA", :latitude=>30.3108262, :longitude=>-97.7399628, :business_hours=>["Monday: 4:00 – 10:00 PM", "Tuesday: 4:00 – 10:00 PM", "Wednesday: 4:00 – 10:00 PM", "Thursday: 4:00 – 10:00 PM", "Friday: 4:00 – 11:00 PM", "Saturday: 4:00 – 11:00 PM", "Sunday: 4:00 – 10:00 PM"], :price=>4, :description=>"Offshoot of the famed Uchi restaurant with upscale sushi & small plates in a farmhouse-chic space.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Cosy", "Romantic", "Upmarket", "Groups", "Happy hour", "Vegetarian options", "Healthy options", "Organic dishes"], ["Outdoor seating", "Curbside pickup"]), :website=>"http://uchikoaustin.com/", :rating=>4.8, :phone=>"(512) 916-4808" },
  {:name=>"Jacoby's Restaurant & Mercantile", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"3235 E Cesar Chavez St, Austin, TX 78702, USA", :latitude=>30.2515037, :longitude=>-97.7073463, :business_hours=>["Monday: Closed", "Tuesday: Closed", "Wednesday: 5:00 – 9:00 PM", "Thursday: 5:00 – 9:00 PM", "Friday: 5:00 – 10:00 PM", "Saturday: 10:00 AM – 2:00 PM, 5:00 – 10:00 PM", "Sunday: 10:00 AM – 2:00 PM"], :price=>3, :description=>"Southern classics elevated by farm-fresh ingredients in a rustic space with a lush garden & a shop.", :category=>"Food", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Restaurant", "Bar", "Casual", "Cosy", "Romantic", "Upmarket", "Happy hour", "Families", "Groups", "Comfort food", "Vegetarian options", "Organic dishes"], []), :website=>"http://www.jacobysaustin.com/", :rating=>4.4, :phone=>"(512) 366-5808" },
  {:name=>"The Roosevelt Room", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"307 W 5th St, Austin, TX 78701, USA", :latitude=>30.2677886, :longitude=>-97.74627729999999, :business_hours=>["Monday: 4:00 PM – 12:00 AM", "Tuesday: Closed", "Wednesday: Closed", "Thursday: Closed", "Friday: 4:00 PM – 2:00 AM", "Saturday: 4:00 PM – 2:00 AM", "Sunday: 3:00 PM – 2:00 AM"], :price=>3, :description=>"Inventive craft cocktails are served in an airy, industrial-chic space with a cozy upstairs lounge.", :category=>"Drinks", :tag_list=>modify_default_tag_list_restaurant(["Food and Drink", "Bar", "Staff temperature checks",  "Delivery", "Cosy", "Upmarket", "Nightlife", "Happy hour", "Groups"], ["Outdoor seating"]), :website=>"http://www.therooseveltroomatx.com/", :rating=>4.7, :phone=>"(512) 494-4094" }
]

# All places are seeded with a default tag_list.  This method modifies the list as appropriate to the activity.
  def modify_default_tag_list_activity(add_tags, remove_tags)
    default_tag_list = []
    tag_list = default_tag_list
    add_tags.each do |tag|
      tag_list << tag
    end
    remove_tags.each do |tag|
      tag_list.delete(tag)
    end
    return tag_list
  end

activities_array = [
  {:name=>"Yoga Hike", :title=>"Yoga + Hiking", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"9707 Anderson Mill Rd, Austin, TX 78750, USA", :latitude=>30.44738779999999, :longitude=>-97.7934241, :business_hours=>["Monday: 9:00 AM – 5:00 PM", "Tuesday: 9:00 AM – 5:00 PM", "Wednesday: 9:00 AM – 5:00 PM", "Thursday: 9:00 AM – 5:00 PM", "Friday: 9:00 AM – 5:00 PM", "Saturday: 9:00 AM – 5:00 PM", "Sunday: 9:00 AM – 5:00 PM"], :price=>nil, :description=>"Yoga Hike provides Fun Team Bonding and Team Building Adventure Activities with a little Yoga added to deepen its participants’ connection to nature and each other. We offer piblic events and privates tours, for company team-building, retreats, bridal showers, bachelor parties or family reunions. Custom tailored to meet the specific needs of a group, based on time of day, fitness level of the team, Sunrises and Sunsets. These events appeal to people who want a unique experience in the Austin area. Our adventures are accessible to Yoga and Hiking, beginners and enthusiast.", :category=>"Wellness", :tag_list=>modify_default_tag_list_activity(["Activity", "Outdoor", "Hike", "Yoga", "Nature", "Adventure", "Wellness", "Relaxation"], []), :phone=>"(512) 337-9472", :website=>"https://yogahike.com/your-trail/", :rating=>nil },
  {:name=>"Mayfield Park and Nature Preserve", :title=>"Visit a Nature Reserve", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"3505 W 35th St, Austin, TX 78703, USA", :latitude=>30.3129736, :longitude=>-97.77162000000001, :business_hours=>["Monday: 5:00 AM – 10:00 PM", "Tuesday: 5:00 AM – 10:00 PM", "Wednesday: 5:00 AM – 10:00 PM", "Thursday: 5:00 AM – 10:00 PM", "Friday: 5:00 AM – 10:00 PM", "Saturday: 5:00 AM – 10:00 PM", "Sunday: 5:00 AM – 10:00 PM"], :price=>nil, :description=>"Quiet 21-acre grounds with walking trails & a wildlife habitat with free-roaming peacocks.", :category=>"Landmarks", :tag_list=>modify_default_tag_list_activity(["Activity", "Outdoor", "Kids", "Park", "Nature", "Wildlife", "Landmarks"], []), :phone=>"(512) 974-6700", :website=>"http://mayfieldpark.org/", :rating=>4.7 },
  {:name=>"Chaparral Ice", :title=>"Go Ice-Skating", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"2525 W Anderson Ln, Austin, TX 78757, USA", :latitude=>30.3548809, :longitude=>-97.73335089999999, :price=>nil, :description=>"Family-owned ice rink offering public skate times, figure skating & hockey lessons & party packages.", :category=>"Activity", :tag_list=>modify_default_tag_list_activity(["Activity", "Indoor", "Ice-skating", "Fitness"], []), :phone=>"(512) 252-8500", :website=>"http://www.chaparralice.com/", :rating=>4.5 },
  {:name=>"Treaty Oak Distilling", :title=>"Visit a Distillery", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"16604 Fitzhugh Rd, Dripping Springs, TX 78620, United States", :latitude=>30.246601022885006, :longitude=>-98.05462353982426, :business_hours=>["Monday, Closed", "Tuesday, Closed", "Wednesday, 12–9pm", "Thursday, 12–9pm", "Friday, 12–9pm", "Saturday, 12–9pm", "Sunday, 12–4pm"], :price=>nil, :description=>"Family & dog-friendly distillery with tasting room & craft cocktails made with Treaty Oak spirits.", :category=>"Activity", :tag_list=>modify_default_tag_list_activity(["Activity", "Indoor", "Historic"], []), :phone=>"(512) 400-4023", :website=>"http://treatyoakdistilling.com/", :rating=>4.7 },
  {:name=>"Blue Starlite Mini Urban Drive In", :title=>"See a Drive-in Movie", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"2015 E M. Franklin Ave, Austin, TX 78723, USA", :latitude=>30.2861372, :longitude=>-97.6968912, :business_hours=>["Monday: 7:45 – 11:30 PM", "Tuesday: 7:45 – 10:00 PM", "Wednesday: 7:45 – 10:00 PM", "Thursday: 7:45 PM – 12:00 AM", "Friday: 7:45 PM – 12:00 AM", "Saturday: 7:45 PM – 12:00 AM", "Sunday: 7:30 – 11:30 PM"], :price=>nil, :description=>"Classic & art-house movies are shown at this popular, old-time drive-in in the middle of the city.", :category=>"Entertainment", :tag_list=>modify_default_tag_list_activity(["Activity", "Outdoor", "Kids", "Movies", "Entertainment"], []), :phone=>"(707) 374-8346", :website=>"http://www.bluestarlitedrivein.com/", :rating=>4.5, },
  {:name=>"Zilker Park", :title=>"Go for a Picnic", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"2207 Lou Neff Rd, Austin, TX 78746, USA", :latitude=>30.2664531, :longitude=>-97.7688115, :business_hours=>nil, :price=>nil, :description=>"351-acre, urban park with botanical gardens, a spring-fed pool, a theater & sports facilities.", :category=>"Outdoors", :tag_list=>modify_default_tag_list_activity(["Activity", "Outdoor", "Kids", "Fitness", "Park"], []), :phone=>"(512) 974-6700", :website=>"https://austintexas.gov/department/zilker-metropolitan-park", :rating=>4.8 },
  {:name=>"Austin Paddle Shack", :title=>"Go Paddle-Boarding", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"600 E Riverside Dr, Austin, TX 78704, USA", :latitude=>30.2524938, :longitude=>-97.74101569999999, :business_hours=>["Monday: 12:00 – 6:00 PM", "Tuesday: Closed", "Wednesday: Closed", "Thursday: Closed", "Friday: 10:00 AM – 6:00 PM", "Saturday: 10:00 AM – 6:00 PM", "Sunday: 10:00 AM – 6:00 PM"], :price=>nil, :description=>"Exploring the Lady Bird Lake with Bat Bridge Kayak Tours, Scenic Skyline Tour, Paddleboard Tours & Rentals.", :category=>"Activity", :tag_list=>modify_default_tag_list_activity(["Activity", "Outdoor", "Fitness", "Sport", "Adventure"], []), :phone=>"(512) 580-9401", :website=>"http://www.austinpaddle.com/", :rating=>4.6 },
  {:name=>"Blanton Museum of Art", :title=>"Visit an Art Museum", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"200 E Martin Luther King Jr Blvd, Austin, TX 78712, USA", :latitude=>30.2808109, :longitude=>-97.7376838, :business_hours=>["Monday: Closed", "Tuesday: Closed", "Wednesday: 10:00 AM – 1:00 PM, 2:00 – 5:00 PM", "Thursday: 10:00 AM – 1:00 PM, 2:00 – 5:00 PM", "Friday: 10:00 AM – 1:00 PM, 2:00 – 5:00 PM", "Saturday: 10:00 AM – 1:00 PM, 2:00 – 5:00 PM", "Sunday: 2:00 – 5:00 PM"], :price=>nil, :description=>"Renaissance to 20th-century American paintings, Latin American art, plus Greek & Roman sculpture.", :category=>"Culture", :tag_list=>modify_default_tag_list_activity(["Activity", "Culture", "Indoor", "Museum", "Kids", "Families"], []), :phone=>"(512) 471-5482", :website=>"https://blantonmuseum.org/", :rating=>4.6 },
  {:name=>"The Domain", :title=>"Shop in Style", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"11410 Century Oaks Terrace, Austin, TX 78758, United States", :latitude=>30.405348566163024, :longitude=>-97.72489412620071, :business_hours=>["Monday, 10am–9pm", "Tuesday, 10am–9pm", "Wednesday, 10am–9pm", "Thursday, 10am–9pm", "Friday, 10am–9pm", "Saturday, 10am–9pm", "Sunday, 12–6pm"], :price=>nil, :description=>"Outdoor mall offering a variety of upscale shops & department stores plus dining options & a cinema.", :category=>"Shopping", :tag_list=>modify_default_tag_list_activity(["Activity", "Shopping"], []), :phone=>"(512) 795-4230", :website=>"https://www.simon.com/mall/the-domain", :rating=>4.5 },
  {:name=>"Bass Concert Hall", :title=>"Music", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"2350 Robert Dedman Dr, Austin, TX 78712, USA", :latitude=>30.2858163, :longitude=>-97.73136919999999, :price=>nil, :description=>"City's largest theater hosting world-class performers in music, drama & dance.", :website=>"http://texasperformingarts.org/", :phone=>"(512) 471-2787", :rating=>4.5, :category=>"Music", :tag_list=>modify_default_tag_list_activity(["Activity", "Music", "Families"], []) },
  {:name=>"Avery Ranch Golf Club", :title=>"Sports", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"10500 Avery Club Dr, Austin, TX 78717, USA", :latitude=>30.50400669999999, :longitude=>-97.7706033, :business_hours=>["Monday: 6:30 AM – 7:30 PM", "Tuesday: 6:30 AM – 7:30 PM", "Wednesday: 6:30 AM – 7:30 PM", "Thursday: 6:30 AM – 7:30 PM", "Friday: 6:30 AM – 7:30 PM", "Saturday: 6:30 AM – 7:30 PM", "Sunday: 6:30 AM – 7:30 PM"], :description=>"Avery Ranch is Texas Hill Country Golf at its finest! Running along Lake Avery, the 18th is Austin's best finishing hole and provides a unique view of the Texas Hill Country.", :price=>nil, :website=>"http://www.averyranchgolf.com/", :phone=>"(512) 248-2442", :rating=>4.2, :category=>"Sport", :tag_list=>modify_default_tag_list_activity(["Activity", "Sport", "Families"], []) },
  {:name=>"Austin Ghost Tours", :title=>"Tours", :location=>Location.find_by(city: "Austin", state: "Texas"), :address=>"4602 White Elm Dr, Austin, TX 78749, USA", :latitude=>30.22842870000001, :longitude=>-97.84204369999999, :business_hours=>["Monday: 10:00 AM – 8:30 PM", "Tuesday: 10:00 AM – 8:30 PM", "Wednesday: 10:00 AM – 8:30 PM", "Thursday: 10:00 AM – 8:30 PM", "Friday: 10:00 AM – 8:30 PM", "Saturday: 10:00 AM – 8:30 PM", "Sunday: Closed"], :description=>"Keeping history alive for 25 years through our friends – the spirits – who have remained to tell their stories. The only Ghost Tour Company born and raised in Austin, Texas!  All stories are original and  thoroughly researched by our team.  Join us!", :price=>nil, :website=>"http://www.austinghosttours.com/", :phone=>"(512) 203-5561", :rating=>4, :category=>"Tours", :tag_list=>modify_default_tag_list_activity(["Activity", "Tours"], [])}
]


API_KEY = ENV["GOOGLE_API_KEY"]
city = "Austin"
state = "Texas"

puts "..................."
puts "Creating restaurants..."

restaurants_array.each_with_index do |place, index|
  place = Place.create(place)   
  puts "-> #{place.name} created. uploading photos...."
  # HARDCODED PHOTOS FROM ASSETS
    # img_path = "app/assets/images/places/#{place.name.gsub(/\s/,'_')}.jpg"
    # place.photos.attach(io: open(img_path), filename: "place_#{index+1}.jpg", content_type: 'image/jpg')
    # puts img_path
      ## place.photo.attach(io: open("app/assets/images/places/default_place.jpg"), filename: "default_place.jpg", content_type: 'image/jpg') if !place.photo.attached?
    # puts "Hard coded photos attached? => #{place.photos.attached?}"



    # ================================================================
  # =================GOOGLE API BEHEMOTH FOR RESTAURANTS====================
  # ================================================================
    city = place.location.city
    state = "Texas"
  
    places_array = []

    # place_names_array.each do |place|
    search_string = "#{place.name.split.join("%20")}%20#{city}%20#{state}"

    puts "search_string: #{search_string}"

    # First, use Find Place request to get place_id
    place_id = HTTParty.get("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{search_string}&inputtype=textquery&key=#{API_KEY}")["candidates"][0]["place_id"]

    puts "place_id = #{place_id}"

      # Do Place Details request using place_id to get more info

      api_link = "https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&fields=name,photos&key=#{API_KEY}"
      # puts "API LINK: #{api_link}"
      result = HTTParty.get(api_link)["result"]


      place_hash = {
        name: result["name"],
        photo: result["photos"]
      }

      photos_json = place_hash[:photo]
      # puts photos_json
      photos_json.each_with_index do |photo_json, i|
        photo_ref = photo_json["photo_reference"]
        # puts photo_ref
        puts "----Google photo API ref #{i+1} obtained"
          link_part_1 = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=#{image_width}&photoreference="
          link_part_2 = photo_ref
          link_part_3 = "&key=#{API_KEY}"
        full_link = "#{link_part_1}#{link_part_2}#{link_part_3}"
          puts ""
          # puts "FULL LINK: #{full_link}"

        # YOLOOOOOOOOOOOOOO. Attaching photos

            place.photos.attach(io: open(full_link), filename: "place_#{index+1}.jpg", content_type: 'image/jpg')

          if i == photos_via_api_limit - 1
            "limit HIT======"
            break
          end
      end
      # places_array << place_hash
      if index == restaurants_seed_limit - 1
        "limit HIT======"
        break
      end
    end
# ================================================================


puts "==> Done creating restaurants."

# ================================================================
# ================================================================
# ================================================================
# ================================================================
# ================================================================
# ================================================================
# ================================================================
# ================================================================
puts "==================================================================================="
puts "..................."
puts "Creating activities..."

activities_array.each_with_index do |place, index|
  place = Place.create(place)
  puts "-> #{place.name} created."

  city = place.location.city
  state = "Texas"

  places_array = []

  # place_names_array.each do |place|
  search_string = "#{place.name.split.join("%20")}%20#{city}%20#{state}"

  puts "search_string: #{search_string}"

  # First, use Find Place request to get place_id
  place_id = HTTParty.get("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{search_string}&inputtype=textquery&key=#{API_KEY}")["candidates"][0]["place_id"]

  puts "place_id = #{place_id}"

    # Do Place Details request using place_id to get more info
    # result = HTTParty.get("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&fields=name,formatted_address,website,geometry,opening_hours,price_level,photos&key=#{API_KEY}")["result"]

    api_link = "https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&fields=name,photos&key=#{API_KEY}"
    # puts "API LINK: #{api_link}"
    result = HTTParty.get(api_link)["result"]
    # puts HTTParty.get("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&fields=name,formatted_address,website,geometry,opening_hours,price_level,photos&key=#{API_KEY}")


    place_hash = {
      name: result["name"],
      photo: result["photos"]
      # latitude: result["geometry"]["location"]["lat"],
      # longitude: result["geometry"]["location"]["lng"],
      # business_hours: result["opening_hours"]["weekday_text"]
      # price: result["price_level"],
      # description: result["website"]
    }


    photos_json = place_hash[:photo]
    # puts photos_json
    photos_json.each_with_index do |photo_json, i|
      photo_ref = photo_json["photo_reference"]
      puts photo_ref
      puts "----Google photo API ref #{i+1} obtained"

      link_part_1 = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1000&photoreference="
      link_part_2 = photo_ref
      # link_part_2 = "ATtYBwKtmVkTPJVISPO3o0tMvyoZ3MvrKaQmACtu61vmFMsNFX36jpCmGBskOQ-CO9S-Gk1oc90zagpJX_LJ2qCErh3axB8K0cXT-iY3OzthRu6ULpG9gxpz_k2WhWntRj_K7d0bcDWUgWLdxzhzV864qW1x_GNgDc57oGJ_DlTwh0g5V8dE"
      link_part_3 = "&key=#{API_KEY}"
      full_link = "#{link_part_1}#{link_part_2}#{link_part_3}"
        puts ""
        # puts "FULL LINK: #{full_link}"

        # YOLOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

          place.photos.attach(io: open(full_link), filename: "place_#{index+1}.jpg", content_type: 'image/jpg')

        if i == photos_via_api_limit - 1
          "limit HIT======"
          break
        end
      end
      # places_array << place_hash
      puts "YEEEEEEEEEEW. Activitiy photos uploaded"
      if index == parks_seed_limit - 1
        "limit HIT======"
        break
      end

# ================================================================
end

puts "==> Done creating activities."

puts "Now we have #{Place.all.count} places! Yeeew!"


# ============ REVIEWS =============
puts "..................."
puts "Creating reviews..."

tips_array = ["Make your reservation early!",
 "Masks are provided by staff if you forgot your own.",
 "Try to get a table out on the patio if you can! More space and fresher air!",
 "Sanitized pens are provided to fill out COVID contact tracing forms.",
 "Floor markings for social distancing are really well-marked to guide patrons.",
 "Protocols and rules are clearly pasted at the front entrance.",
 "No cash accepted!  Be sure to bring only contactless payment options!  Or pay with your life!",
 "Staff is very mindful about Covid safety!",
 "I was delighted to lather their scented hand sanitizer all over my hand before eating.",
 "Staff are stationed by the entrance to scan your temperature as you enter the premise."]

tip_index = 0
users = User.all
user_index = 0
total_users = User.count
Place.all.each do |place|
  rand(2..5).times do
    user = users[user_index % total_users]
    review = Review::create!(user: user, place: place, covid_rating: rand(7..10), \
                            tip: tips_array[tip_index % tips_array.length], \
                            #tip: "Try the #{Faker::Food.dish || Faker::Movies::Hobbit.quote || Faker::Movies::Lebowski.quote}", \
                            hand_sanitizer: [0, 1].sample, \
                            face_mask: [0, 1].sample, \
                            temperature_checks: [0, 1].sample, \
                            social_distancing: [0, 1].sample, \
                            covid_protocols: [0, 1].sample, \
                            contact_tracing: [0, 1].sample, \
                            exposure_risk: rand(1..5), \
                            covid_consciousness: rand(1..5), \
                            covid_enforcement: rand(1..5), \
                            covid_creativity: rand(1..5) \
                            )
    place = review.place
    if place.covid_score.nil?
      place.covid_score = review.covid_rating
    else
      score = (( place.reviews.count - 1 ) * place.covid_score.to_f + review.covid_rating) / (place.reviews.count)
      place.covid_score = score.round(1)
    end
    place.save
    user_index += 1
    tip_index += 1
    puts "#{user.first_name} #{user.last_name} wrote a review for #{review.place.name}! Now we have #{Review.all.count} review(s)!"
  end
end


puts "==> FINISHED! Now we have #{Review.all.count} review(s)"
