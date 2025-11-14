class WebPushRegistrationBlueprint < Blueprinter::Base
  identifier :id

  field :endpoint
  field :expires_at

end