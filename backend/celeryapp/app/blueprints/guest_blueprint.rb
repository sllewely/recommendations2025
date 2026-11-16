class GuestBlueprint < Blueprinter::Base
  identifier :id
  fields :name

  # only for the guest themselves, so their browser can remember them
  view :self do
    fields :email, :token
  end
end
