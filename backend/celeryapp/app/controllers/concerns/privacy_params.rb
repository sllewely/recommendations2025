module PrivacyParams
  extend ActiveSupport::Concern

  included do
    rescue_from FeedItem::InvalidAudience, with: :render_invalid_audience
  end

  private

  # Parses privacy, privacy_user_ids[] and privacy_circle_ids[].
  # Returns { visibility: nil } when no privacy was sent, leaving the existing setting unchanged.
  def privacy_params
    visibility = params[:privacy].presence
    return { visibility: nil } if visibility.nil?

    unless FeedItem.visibilities.key?(visibility.to_s)
      raise FeedItem::InvalidAudience, "invalid privacy '#{visibility}'"
    end

    {
      visibility: visibility.to_s,
      user_ids: Array(params[:privacy_user_ids]).map(&:to_s),
      circle_ids: Array(params[:privacy_circle_ids]).map(&:to_s),
    }
  end

  def render_invalid_audience(exception)
    render json: { error: exception.message }, status: :unprocessable_content
  end
end
