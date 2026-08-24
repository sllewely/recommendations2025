class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :reactable, polymorphic: true
end