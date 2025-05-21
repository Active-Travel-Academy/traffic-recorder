module JourneyToggleable
  extend ActiveSupport::Concern

  def enable_all_journeys
    toggleable_resource.journeys.enable_all!
    redirect_to polymorphic_path(toggleable_resource_link, page: params[:all_journeys][:page])
  end

  def disable_all_journeys
    toggleable_resource.journeys.disable_all!
    redirect_to polymorphic_path(toggleable_resource_link, page: params[:all_journeys][:page])
  end

  def enable_page_journeys
    page_journeys.enable_all!
    redirect_to polymorphic_path(toggleable_resource_link, page: params[:all_journeys][:page])
  end

  def disable_page_journeys
    page_journeys.disable_all!
    redirect_to polymorphic_path(toggleable_resource_link, page: params[:all_journeys][:page])
  end

  private

  def toggleable_journey_ids
    JSON.parse(params[:all_journeys][:journey_ids])
  end

  def page_journeys
    toggleable_resource.journeys.where(id: toggleable_journey_ids)
  end
end
