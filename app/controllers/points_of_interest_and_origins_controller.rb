class PointsOfInterestAndOriginsController < ApplicationController
  before_action :set_ltn

  def index
    @pois = @ltn.point_of_interests
    @origins = @ltn.origins
  end

  def create
    @ltn.create_poi_origin_journeys!
    flash[:notice] = "Journeys created successfully."
    redirect_to ltn_path(@ltn)
  end

  private

  def set_ltn
    @ltn = current_user.ltns.find(params[:ltn_id])
  end
end
