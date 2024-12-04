require "rails_helper"

Rails.application.load_tasks

describe "pull_routes" do
  include_context "mapbox_responses"

  before do
    allow(Mapbox::Directions).to receive(:directions).and_return(mapbox_response)
  end

  describe ":infrequently_routed" do
    it do
      expect { Rake::Task["pull_routes:infrequently_routed"].invoke }.to change {
        JourneyRun.count
      }.by(Journey.where(type: :infrequently_routed, disabled: false).count)
    end
  end

  describe ":test_routes" do
    it do
      expected_routing_count = Journey.where(type: :test_routing, disabled: false).count
      expect(expected_routing_count).not_to eq 0

      expect { Rake::Task["pull_routes:test_routes"].invoke }.to change {
        JourneyRun.count
      }.by(expected_routing_count).and(
        change { Journey.where(type: :test_routing, disabled: false).count }.to(0)
      )
    end
  end
end
