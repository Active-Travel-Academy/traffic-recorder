class PointOfInterest < ApplicationRecord
  belongs_to :ltn
  has_many :journeys, dependent: :nullify

  validates :lat, presence: true
  validates :lng, presence: true
  validates :name, presence: true

  def self.locate(poi:, lat:, lng:, limit: 25)
    return [] if poi.blank? || lat.blank? || lng.blank?

    Mapbox.request(
      :get, "/search/searchbox/v1/category/#{poi}?language=en&limit=#{limit}&proximity=#{lng}%2C#{lat}", nil
    )[0]
  end

  # only use to generate CATEGORYS manually
  def self.categories
    Mapbox.request(
      :get, '/search/searchbox/v1/list/category', nil
    )[0]['listItems'].map { |li| li['canonical_id'] }
  end

  CATEGORIES = %w[
    services shopping food_and_drink food health_services office restaurant
    education transportation grocery apartment_or_condo place_of_worship
    outdoors school financial_services clothing_store lodging supermarket
    wholesale_store beauty_store auto_repair cafe salon bus_stop government
    real_estate_agent medical_practice park tourist_attraction temple sports
    doctors_office bank fast_food hairdresser nightlife hotel entertainment
    pharmacy consulting bar church farm coffee medical_clinic lawyer
    coffee_shop bakery repair_shop dentist factory photographer shipping_store
    electronics_shop home fitness_center furniture_store shopping_mall atm
    car_dealership travel_agency hospital insurance_broker clothing
    alternative_healthcare post_office advertising_agency it historic_site
    gas_station hospital_unit hardware_store phone_store mosque commercial
    parking_lot jewelry_store river monument lake elementary_school
    convenience_store physiotherapist dessert_shop psychotherapist playground
    tailor nongovernmental_organization laundry warehouse market shoe_store
    car_wash pet_store kindergarten cemetery sports_club field gift_shop
    butcher_shop landscaping care_services florist psychological_services
    charging_station bed_and_breakfast garden chiropractor photo_store
    car_rental spa college womens_clothing_store public_transportation_station
    internet_cafe social_club design_studio copyshop mountain
    paper_goods_store liquor_store ice_cream pizza_restaurant event_planner
    massage_shop medical_supply_store employment_agency art community_center
    book_store nail_salon childcare teahouse tobacco_shop taxi tax_advisor
    event_space veterinarian mexican_restaurant museum university studio
    assisted_living_facility medical_laboratory equipment_rental forest
    indian_restaurant driving_school asian_restaurant high_school optician
    deli sports_shop bicycle_shop hostel library arts_and_craft_store
    department_store island dance_studio boutique food_court diner_restaurant
    storage fashion_accessory_shop health_food_store counselling tutor
    tattoo_parlour dry_cleaners motorcycle_dealer bridge nightclub
    fire_station art_gallery police_station yoga_studio fabric_store
    indonesian_restaurant chinese_restaurant video_game_store news_kiosk
    funeral_home music_school theme_park breakfast_restaurant toy_store
    seafood_restaurant buddhist_temple japanese_restaurant soccer_field
    brunch_restaurant notary juice_bar noodle_restaurant language_school
    fishing_store government_offices bus_station theatre furniture_maker
    baby_goods_shop university_building burger_restaurant townhall swimming_pool
    dormitory recording_studio pub conference_center charity taco_shop winery
    snack_bar public_artwork outdoor_sculpture music_shop italian_restaurant
    laboratory music_venue garden_store sandwich_shop barbeque_restaurant
    stadium tourist_information antique_shop waste_transfer_station
    recycling_center american_restaurant canal cinema nature_reserve
    tennis_courts lighting_store pawnshop rehabilitation_center railway_station
    psychic mattress_store thrift_shop vape_shop motel golf_course radio_studio
    rest_area locksmith vacation_rental watch_store thai_restaurant labor_union
    campground bridal_shop boat_rental arts_center video_store
    recreation_center sushi_restaurant basketball_court cobbler brewery
    kitchen_store party_store shoe_repair bubble_tea airport leather_goods
    martial_arts_studio coworking_space home_repair beach outlet_store
    sewing_shop courthouse cannabis_dispensary fair_grounds stable
    pilates_studio concert_hall hobby_shop currency_exchange trade_school
    gymnastics herbalist frame_store discount_store donut_shop carpet_store
    casino tanning_salon karaoke_bar gun_store camera_shop marina viewpoint
    buffet_restaurant wine_bar animal_shelter turkish_restaurant
    tapas_restaurant pier spanish_restaurant television_studio cocktail_bar
    korean_restaurant billiards vietnamese_restaurant baseball_field tours
    french_restaurant dog_park waste_disposal skatepark picnic_shelter
    photo_lab bookmaker steakhouse cheese_shop fish_and_chips_restaurant
    greek_restaurant fireworks_store military_office sauna sports_center
    vineyard sports_bar hookah_lounge beer_bar mediterranean_restaurant
    gastropub african_restaurant community_college middle_eastern_restaurant
    prison salad_bar zoo racetrack climbing climbing_gym dam dialysis_center
    synagogue coffee_roaster emergency_room hunting_store bowling_alley
    boxing_gym waterfall luggage_store filipino_restaurant bagel_shop fishing
    cricket_club aquarium light_rail_station german_restaurant hot_dog_stand
    motorsports_store ice_rink carribean_restaurant ski_area
    frozen_yogurt_shop military_base distillery summer_camp fishmonger
    exhibit embassy treecare biergarten surfboard_store ramen_restaurant
    resort hunting_area check_cashing disc_golf_course miniature_golf gay_bar
    optometrist water_park observatory cable_car cave plaza lounge
    korean_barbeque_restaurant hawaiian_restaurant town portuguese_restaurant
    latin_american_restaurant fountain duty_free_shop brazilian_restaurant
    skydiving_drop_zone english_restaurant cuban_restaurant train
    persian_restaurant rugby_stadium creole_restaurant gluten_free_restaurant
    trailhead carpet_cleaner airport_terminal tiki_bar street intersection
    windmill information_technology_company bike_rental boat_or_ferry
    food_truck veterans_service wings_joint arcade outdoors_store surf_spot
    irish_pub peruvian_restaurant track soccer_stadium chocolate_shop
    cruise mountain_hut theme_park_attraction service_area ski_shop
    lighthouse airport_gate baseball_stadium football_stadium go_kart_racing
    tech_startup basketball_stadium states_and_municipalities dive_bar
    laser_tag political_party_office driving_range well hockey_stadium stripclub
    beach_bar tunnel waffle_shop ski_trail tennis_stadium boat_launch meeting_room
    rafting_spot scuba_diving_shop speakeasy university_book_store
    university_laboratory zoo_exhibit chairlift corporate_amenity indoor_cycling
    racecourse tree turkish_coffeehouse baggage_claim champagne_bar sake_bar
    village airport_ticket_counter beer_festival bus_line city country county
    graffiti hotel_bar lgbtq_organization moving_target neighbourhood planetarium
    pop_up_shop railway_platform road state variety_store whiskey_bar
  ].freeze

  validates :category, inclusion: { in: CATEGORIES }, allow_blank: true
end
