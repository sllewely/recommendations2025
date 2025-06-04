class ImagesController < ApplicationController
  require 'debug'
  include S3ImageHelper

  def upload_url
    debugger
    object_key = "profile_image/#{current_user.id}"
    render json: { upload_url: S3ImageHelper.get_presigned_url(object_key) }, status: :ok
  end

  private
end
