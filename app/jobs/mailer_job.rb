class MailerJob < ApplicationJob
  queue_as :default

  def perform(mailer_class, mailer_method, user, activation_token)
    # Gọi phương thức gửi email
    user.activation_token = activation_token
    mailer_class.constantize.send(mailer_method, user).deliver_now
  end

end

