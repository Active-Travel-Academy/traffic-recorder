class PointOfInterestsController < ApplicationController
  before_action :set_ltn
  include JourneyToggleable

  def new
    @poi = @ltn.point_of_interests.build
  end

  def show
    point_of_interest
    @pagy, @journeys = pagy(point_of_interest.journeys.order(:id), limit: 50)
  end

  def create
    @poi = @ltn.point_of_interests.build(permitted_params)
    if @poi.save
      redirect_to ltn_points_of_interest_and_origins_path(@ltn), notice: "#{@poi.name} successfully created."
    else
      render :new, status: 422
    end
  end

  def update
    point_of_interest.update(update_params)
    respond_to do |format|
      format.html { redirect_to point_of_interest }
      format.turbo_stream # Renders update.turbo_stream.erb
    end
  end

  def destroy
    if point_of_interest.destroy
      redirect_to ltn_points_of_interest_and_origins_path(@ltn), notice: "Point of Interest #{point_of_interest.name} was successfully destroyed."
    else
      redirect_to point_of_interest, notice: 'point_of_interest could not be destroyed', status: :see_other
    end
  end

  def search
    render json: PointOfInterest.locate(poi: params[:cat], lat: params[:lat], lng: params[:lng]).to_json
  end

  private

  def toggleable_resource
    point_of_interest
  end

  def toggleable_resource_link
    [@ltn, point_of_interest]
  end

  def point_of_interest
    @point_of_interest ||= @ltn.point_of_interests.find(params[:id])
  end

  def set_ltn
    @ltn = current_user.ltns.find(params[:ltn_id])
  end

  def permitted_params
    params.require(:point_of_interest).permit(:lat, :lng, :name, :category)
  end
end
