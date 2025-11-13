require 'web-push'

module PushNotification
  # make this a job
  def self.send_push_notification(user, message_title, message_body)

    message_json = {
      title: message_title,
      body: message_body,
      # icon: ActionController::Base.helpers.asset_url("app-icons/icon-192.png")
    }.to_json

    user.web_push_registrations.each do |reg|
      # TODO: don't forget to later delete if call fails
      response = WebPush.payload_send(
        message: message_json,
        endpoint: reg.endpoint,
        p256dh: reg.p256dh,
        auth: reg.auth,
        vapid: {
          subject: "mailto:support@bumblebeans.social",
          public_key: ENV['VAPID_PUBLIC_KEY'],
          private_key: ENV['VAPID_PRIVATE_KEY']
        }
      )

      # TODO: it would be awesome to log failures somewhere
      puts response
    end
  end
end