class PasswordResetMailer < ApplicationMailer
  default from: 'no-reply@generalpublic.com'

  def reset_email
    @user = params[:user]
    @token = params[:token]
    @url = password_reset_url(@user.email, @token)
    mail(to: @user.email, subject: 'Password Reset Instructions')
  end

  private
  def password_reset_url(email, token)
    host = Rails.application.config.x.app_host
    "#{host}/password_resets/edit?email=#{email}&token=#{token}"
  end
end
