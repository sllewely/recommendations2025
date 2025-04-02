class ApplicationRecord < ActiveRecord::Base
  require './app/helpers/date_helper'

  primary_abstract_class

  def errors_to_s
    self.errors.map do |err|
      "#{err.attribute}: #{err.message}"
    end.join(', ')
  end
end
