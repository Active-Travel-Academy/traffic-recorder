require 'rails_helper'

RSpec.describe JourneyRun, type: :model do
  let(:ltn) { ltns(:dulwich) }
  describe ".to_csv" do
    context "errors" do
      let(:error) do
        catch(:invalid_input) do
          described_class.to_csv(from: from_date, to: to_date, ltn:)
        end
      end

      context "asking for more than one month" do
        let(:from_date) { Date.new(2020, 2, 2) }
        let(:to_date) { Date.new(2025, 2, 1) }

        before do
          stub_const("JourneyRun::MAX_RUNS_COUNT", 1)
        end

        it "can only get N runs at a time" do
          expect(error).to eq "Can only ask for 1 journey runs at a time.  The between '2020-02-02' and '2025-02-01' there are 11 journey runs."
        end
      end

      context "from date is before to date" do
        let(:from_date) { Date.new(2025, 2, 2) }
        let(:to_date) { Date.new(2025, 2, 1) }

        it "can only get 1 month at a time" do
          expect(error).to eq "From: '2025-02-02' must be before To: '2025-02-01'"
        end
      end
    end

    context "without overview_polyline" do
      it do
        csv = described_class.to_csv(from: Date.new(2021, 3, 24), to: Date.new(2021, 3, 26), ltn:)
        parsed = CSV.parse(csv, headers: true)
        expect(parsed.headers).to eq [
          "scheme", "mode", "journey_id", "origin_lat", "origin_lng", "dest_lat", "dest_lng",
          "run_id", "duration", "duration_in_traffic", "incidents", "distance", "created_at"
        ]
        first = parsed.first
        aggregate_failures do
          expect(first["scheme"]).to eq "Dulwich"
          expect(first["mode"]).to eq "driving"
          expect(first["origin_lat"]).to eq "51.444084"
          expect(first["origin_lng"]).to eq "-0.08521915"
          expect(first["dest_lat"]).to eq "51.451654"
          expect(first["dest_lng"]).to eq "-0.09603918"
          expect(first["run_id"]).to eq "1020"
          expect(first["duration"]).to eq "204"
          expect(first["duration_in_traffic"]).to eq "258"
          expect(first["incidents"]).to eq "\"The road is closed\""
          expect(first["distance"]).to eq "1260"
        end
      end
    end

    context "with overview_polyline" do
      let(:journey_run) { journey_runs(:infrequently_routed_enabled_first) }

      it do
        csv = described_class.to_csv(from: Date.new(2021, 3, 24), to: Date.new(2021, 3, 26), ltn:, overview_polyline: true)
        parsed = CSV.parse(csv, headers: true)
        expect(parsed.headers).to eq [
          "scheme", "mode", "journey_id", "origin_lat", "origin_lng", "dest_lat", "dest_lng",
          "run_id", "duration", "duration_in_traffic", "incidents", "distance", "created_at", "overview_polyline", "congestion_numeric"
        ]
        expect(parsed.first["run_id"]).to eq journey_run.run_id.to_s
        expect(parsed.first["overview_polyline"]).to eq journey_run.overview_polyline.to_json
        expect(parsed.first["congestion_numeric"]).to eq "[null,1,2,3,null,10]"
      end
    end
  end
end
