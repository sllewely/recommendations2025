class ImagesController < ApplicationController
  include S3ImageHelper

  def profile_picture

    file = params[:file]
    res = S3ImageHelper.put_object("profile_pictures/#{current_user.id}", file.read)

    render json: {}, status: :ok
  end

  def signed_upload_url
    # may need to delete the old one
    res = S3ImageHelper.presigned_url_put_object("profile_picture/#{current_user.id}")

    logger.warn "signed upload url: #{res}"

    render json: { url: res }, status: :ok
  end

  def signed_get_url
    # may need to delete the old one
    res = S3ImageHelper.presigned_url_get_object("profile_picture/#{current_user.id}")

    logger.warn "signed get url: #{res}"

    render json: { url: res }, status: :ok
  end
end
