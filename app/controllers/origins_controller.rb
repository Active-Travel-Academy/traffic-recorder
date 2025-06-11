class OriginsController < ApplicationController
  before_action :set_ltn
  include JourneyToggleable

  def new
    @origin = @ltn.origins.build
  end

  def show
    origin
    @pagy, @journeys = pagy(origin.journeys.ordered, limit: 50)
  end

  def create
    @origin = @ltn.origins.build(permitted_params)
    if @origin.save
      redirect_to ltn_points_of_interest_and_origins_path(@ltn), notice: "#{@origin.name} successfully created."
    else
      render :new, status: 422
    end
  end

  def destroy
    if origin.destroy
      redirect_to ltn_points_of_interest_and_origins_path(@ltn), notice: "Point of Interest #{origin.name} was successfully destroyed."
    else
      redirect_to origin, notice: 'origin could not be destroyed', status: :see_other
    end
  end

  private

  def toggleable_resource
    origin
  end

  def toggleable_resource_link
    [ @ltn, origin ]
  end

  def origin
    @origin ||= @ltn.origins.find(params[:id])
  end

  def set_ltn
    @ltn = current_user.ltns.find(params[:ltn_id])
  end

  def permitted_params
    params.require(:origin).permit(:lat, :lng, :name)
  end
end
