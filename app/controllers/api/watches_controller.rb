# frozen_string_literal: true

class API::WatchesController < API::BaseController
  before_action :require_login
  include Rails.application.routes.url_helpers

  def index
    @watches =  Watch.preload(:watchable).order(created_at: :desc).page(params[:page])
  end

  def create
    @watch = Watch.new(
      user: current_user,
      watchable: watchable
    )

    @watch.save!
    render json: @watch
  end

  def destroy
    @watch = Watch.find(params[:id])
    @watch.destroy
    head :no_content
  end

  private

  def watchable
    params[:watchable_type].constantize.find_by(id: params[:watchable_id])
  end
end
