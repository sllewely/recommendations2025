class ApplicationMailer < ActionMailer::Base
  default from: 'Celery <noreply@bumblebeans.social>'
  layout "mailer"
end
