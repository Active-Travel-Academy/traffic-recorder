# frozen_string_literal: true
shared_context 'mapbox_responses' do
  let(:mapbox_response) do
    [{"routes"=>
      [{"weight_typical"=>1966.177,
        "waypoints"=>[{"distance"=>54.341, "name"=>"Tokenhouse Yard", "location"=>[-0.088084, 51.515469]}, {"distance"=>2.584, "name"=>"Ufford Street", "location"=>[-0.105744, 51.502522]}],
        "duration_typical"=>1013.81,
        "weight_name"=>"auto",
        "weight"=>1966.262,
        "duration"=>1011.647,
        "distance"=>3550.213,
        "legs"=>
      [{"via_waypoints"=>[],
        "admins"=>[{"iso_3166_1_alpha3"=>"GBR", "iso_3166_1"=>"GB"}],
        "incidents"=>
      [{"id"=>"4658460782881710",
        "type"=>"construction",
        "creation_time"=>"2024-12-04T11:05:41Z",
        "start_time"=>"2024-08-29T23:00:00Z",
        "end_time"=>"2026-08-31T22:59:00Z",
        "iso_3166_1_alpha2"=>"GB",
        "iso_3166_1_alpha3"=>"GBR",
        "description"=>"Nicholson Street: construction between A201 Blackfriars Road and Chancel Street",
        "long_description"=>"One lane closed due to construction on Nicholson Street both ways between A201 Blackfriars Road and Chancel Street.",
        "impact"=>"low",
        "alertc_codes"=>[736],
        "traffic_codes"=>{"incident_primary_code"=>736},
        "lanes_blocked"=>[],
        "length"=>98,
        "south"=>51.505153,
        "west"=>-0.104446,
        "north"=>51.505203,
        "east"=>-0.103116,
        "congestion"=>{"value"=>101},
        "geometry_index_start"=>183,
        "geometry_index_end"=>184,
        "affected_road_names"=>["Blackfriars Road/A201", "Nicholson Street"],
        "affected_road_names_unknown"=>["Blackfriars Road/A201", "Nicholson Street"]}],
      "annotation"=>
      {"congestion_numeric"=> [0,1,2,3,4]},
        "weight_typical"=>1966.177,
        "duration_typical"=>1013.81,
        "weight"=>1966.262,
        "duration"=>1011.647,
        "steps"=>[],
        "distance"=>3550.213,
        "summary"=>"Queen Victoria Street, A201"}],
        "geometry"=>
      {"coordinates"=>[[-0.088084, 51.515469],
                       [-0.088332, 51.515477],
                       [-0.088338, 51.515478],
                       [-0.088382, 51.515204]],
      "type"=>"LineString"}}],
      "code"=>"Ok",
      "uuid"=>"uuid"
    }]
  end
end
