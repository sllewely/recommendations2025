require 'web-push'

module PushNotification
  # make this a job
  def self.send_push_notification
    push_endpoint = "https://fcm.googleapis.com/fcm/send/cnE0rev18wM:APA91bFn_H85s3unmTB-dUSd1tSku0fv3lTsHVe_ooEFwiDjZRfDHp2TjIBjzq_jHZ5F8AQzct9juAL0odCZuZ6rmjoJB7RrDipeFAgAUU6KZ5Ucs6btBMOB-5sZE1cdT_XlRrPNrngK"
    keys = {

      auth:
        "OTqLglSlu4-sccDA8rQGLQ",
      p256dh:
        "BMmVsWpbfKI7u-h6R45c28yNz09dIwIqIXvtoHBZyD3XrI4BpXGMpbPCdutyvT4-qBzMjih20YocwTNmI04zMLU"
    }

    message_json = {
      title: "test notification",
      body: "spam",
      # icon: ActionController::Base.helpers.asset_url("app-icons/icon-192.png")
    }.to_json

    response = WebPush.payload_send(
      message: message_json,
      endpoint: push_endpoint,
      p256dh: keys[:p256dh],
      auth: keys[:auth],
      vapid: {
        subject: "mailto:support@bumblebeans.social",
        public_key: ENV['VAPID_PUBLIC_KEY'],
        private_key: ENV['VAPID_PRIVATE_KEY']
      }
    )

    puts response

    response

  end
end