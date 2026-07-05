class ReactionsController < ApplicationController
  def create
    reaction = Reaction.find_or_initialize_by(reaction_params.merge(user: @current_user))
    if reaction
      render json: reaction, status: :ok and return
    end
    render json: { error: 'Reaction not found' }, status: :not_found

  end

  private

  def reaction_params
    params.permit(:id, :react, :commentable_type, :commentable_id)
  end
end