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
          "Scheme", "Mode", "Journey ID", "Journey Name", "Origin Lat", "Origin Long", "Dest Lat", "Dest Long",
          "Run ID", "Duration", "Duration In Traffic", "Incidents", "Distance", "Created At"
        ]
        first = parsed.first
        aggregate_failures do
          expect(first["Journey Name"]).to eq "Infrequently routed enabled"
          expect(first["Scheme"]).to eq "Dulwich"
          expect(first["Mode"]).to eq "driving"
          expect(first["Origin Lat"]).to eq "51.444084"
          expect(first["Origin Long"]).to eq "-0.08521915"
          expect(first["Dest Lat"]).to eq "51.451654"
          expect(first["Dest Long"]).to eq "-0.09603918"
          expect(first["Run ID"]).to eq "1020"
          expect(first["Duration"]).to eq "204"
          expect(first["Duration In Traffic"]).to eq "258"
          expect(first["Incidents"]).to eq "The road is closed"
          expect(first["Distance"]).to eq "1260"
        end
      end
    end

    context "with overview_polyline" do
      let(:journey_run) { journey_runs(:infrequently_routed_enabled_first) }

      it do
        csv = described_class.to_csv(from: Date.new(2021, 3, 24), to: Date.new(2021, 3, 26), ltn:, overview_polyline: true)
        parsed = CSV.parse(csv, headers: true)
        expect(parsed.headers).to eq [
          "Scheme", "Mode", "Journey ID", "Journey Name", "Origin Lat", "Origin Long", "Dest Lat", "Dest Long",
          "Run ID", "Duration", "Duration In Traffic", "Incidents", "Distance", "Created At",
          "Overview Polyline", "Congestion Numeric"
        ]
        expect(parsed.first["Run ID"]).to eq journey_run.run_id.to_s
        expect(parsed.first["Overview Polyline"]).to eq journey_run.overview_polyline.to_json
        expect(parsed.first["Congestion Numeric"]).to eq "[null,1,2,3,null,10]"
      end
    end
  end
end
