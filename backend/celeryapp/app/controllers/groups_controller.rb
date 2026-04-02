class GroupsController < ApplicationController

  def index
    query = Group.all
    if params[:name]
      query = query.by_name(params[:name])
    end

    render json: query, status: :ok
  end

  def show
    group_id = params[:id]

    group = Group.find_by(id: group_id)
    render json: {}, status: :not_found and return if group.nil?

    render json: GroupBlueprint.render(group), status: :ok
  end

  def join
    group_id = params[:id]
    group = Group.find_by(id: group_id)
    render json: {}, status: :not_found and return if group.nil?

    group.users << current_user

    render json: GroupBlueprint.render(group), status: :ok

  rescue ActiveRecord::RecordNotUnique => e
    render json: { error: "Already a member of group #{group.name}" }, status: :unprocessable_entity
  end

  def posts
    group_id = params[:id]
    group = Group.find_by(id: group_id)
    render json: {}, status: :not_found and return if group.nil?

    feed = FeedItem.by_friends(group.users.pluck(:id))

    # TODO: privacy
    @pagy, @feed_items = pagy(feed, limit: 30)
    render json: {
      feed_items: FeedItemBlueprint.render_as_hash(@feed_items, current_user: current_user),
      pagy: @pagy,
    }, status: :ok

  end

end