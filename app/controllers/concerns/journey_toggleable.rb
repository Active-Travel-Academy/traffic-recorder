module JourneyToggleable
  extend ActiveSupport::Concern

  def enable_journeys
    toggleable_journeys.enable_all!
    redirect_to polymorphic_path(toggleable_resource_link, page: params[:manage_journeys][:page])
  end

  def disable_journeys
    toggleable_journeys.disable_all!
    redirect_to polymorphic_path(toggleable_resource_link, page: params[:manage_journeys][:page])
  end

  def test_journeys
    toggleable_journeys.update_all(type: :test_routing, updated_at: Time.current)
    redirect_to polymorphic_path(toggleable_resource_link, page: params[:manage_journeys][:page]), notice: "Journeys will be run within the next two minutes"
  end

  private

  def toggleable_journeys
    if ActiveRecord::Type::Boolean.new.cast(params[:manage_journeys][:all_journeys])
      toggleable_resource.journeys
    else
      toggleable_resource.journeys.where(id: toggleable_journey_ids)
    end
  end

  def toggleable_journey_ids
    params[:manage_journeys][:journey_ids]&.split(',') || []
  end
end
