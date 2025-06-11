class ImagesController < ApplicationController
  include S3ImageHelper

  def upload_url
    object_key = "profile_image-#{current_user.id}"
    upload_url = S3ImageHelper.get_presigned_url(object_key)
    render json: { upload_url: upload_url }, status: :ok
  end

  private
end
