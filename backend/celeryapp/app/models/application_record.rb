class ApplicationRecord < ActiveRecord::Base
  require './app/helpers/date_helper'
  
  primary_abstract_class
end
