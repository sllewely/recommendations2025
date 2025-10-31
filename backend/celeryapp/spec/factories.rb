# Disable strict loading checks from this guide:
# https://thoughtbot.com/blog/strict-loading-in-rails-8-a-railsy-way-to-avoid-n-1-queries
FactoryBot.define do

  after :build do |record|
    if record.is_a? ActiveRecord::Base
      record.strict_loading! false
    end
  end

  after :stub do |record|
    if record.is_a? ActiveRecord::Base
      record.strict_loading! false
    end
  end
end