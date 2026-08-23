class ReactionsController < ApplicationController
  def create
    retrieve_params = reaction_params.merge(user_id: current_user.id).tap { |h| h.delete('react') }
    reaction = Reaction.find_or_initialize_by(retrieve_params)
    # TODO: validate react
    reaction.react = params[:react]
    if reaction.save!
      render json: reaction, status: :ok and return
    end
    render json: { error: 'Reaction not found' }, status: :not_found

  end

  private

  def reaction_params
    params.permit(:id, :react, :reactable_type, :reactable_id)
  end
end