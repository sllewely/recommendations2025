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

end