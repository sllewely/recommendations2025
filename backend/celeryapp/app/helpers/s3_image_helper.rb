require 'aws-sdk-s3'

module S3ImageHelper
  CLOUDFLARE_BUCKET = case Rails.env
                      when "production"
                        "bumblebeans-images-prod"
                      when "development"
                        "bumblebeans-images-dev"
                      end
  CONTENT_TYPE = "image/jpeg"

  def self.s3_client
    credentials = Aws::Credentials.new(ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"])
    Aws::S3::Client.new(
      region: "us-east-2",
      credentials: credentials
    )
  end

  def self.cloudflare_client
    Aws::S3::Client.new(
      region: "auto",
      endpoint: "https://66dabec2b054e432bd1f5cd7a6efefbd.r2.cloudflarestorage.com",
      credentials: Aws::Credentials.new(
        ENV["CLOUDFLARE_ACCESS_KEY_ID"],
        ENV["CLOUDFLARE_SECRET_ACCESS_KEY"]
      ),

    )

  end

  def self.put_object(object_key, file)
    s3_client.put_object(
      bucket: BUCKET,
      key: object_key,
      body: file,
      content_type: CONTENT_TYPE
    )
  end

  def self.get_object(object_key)
    s3_client.get_object(
      bucket: BUCKET,
      key: object_key
    )
  end

  # This... could be used to upload files directly from the frontend without sending to the backend
  # but I got a 403 Forbidden error with no further details when I tried
  def self.presigned_url_put_object(object_key)
    signer = Aws::S3::Presigner.new(client: cloudflare_client)

    signer.presigned_url(:put_object,
                         bucket: CLOUDFLARE_BUCKET,
                         key: object_key,
    )
  end
end