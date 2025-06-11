class ImagesController < ApplicationController
  include S3ImageHelper

  def profile_picture

    file = params[:file]
    res = S3ImageHelper.put_object("profile_pictures/#{current_user.id}", file.read)

    render json: {}, status: :ok

  end
end
