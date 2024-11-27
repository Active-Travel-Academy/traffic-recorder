namespace :pull_routes do
  task infrequently_routed: :environment do
    Ltn.find_each do |ltn|
      run = nil
      ltn.journeys.where(disabled: false, type: :infrequently_routed).find_each do |journey|
        run ||= ltn.runs.create(mode: "driving")
        journey.route!(run)
      end
    end
  end

  task test_routes: :environment do
    Ltn.find_each do |ltn|
      run = nil
      ltn.journeys.where(disabled: false, type: :test_routing).find_each do |journey|
        run ||= ltn.runs.create(mode: "test_driving")
        journey.route!(run)
        journey.update!(type: :infrequently_routed)
      end
    end
  end
end

