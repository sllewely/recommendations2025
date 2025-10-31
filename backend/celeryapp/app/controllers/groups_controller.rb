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

    render json: group, status: :ok
  end

end