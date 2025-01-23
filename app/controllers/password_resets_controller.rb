class PasswordResetsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user
      token = user.generate_password_reset
      PasswordResetMailer.with(user: user, token: token).reset_email.deliver_now
    end
    render json: { message: "If your email is found, you will receive a password reset link." }
  end

  def edit
    render json: { message: "token is valid." } if valid_reset_request?
  end

  def update
    user = User.find_by(email: params[:email])
    if user&.valid_password_reset_token?(params[:token])
      if user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        render json: { message: "Password has been sucessfully updated!" }
      else
        render json: { error: user.errors.full_messages.join(", ") }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid or expired token." }, status: :unprocessable_entity
    end
  end

  private

  def valid_reset_request?
    user = User.find_by(email: params[:email])
    user&.valid_password_reset_token?(params[:token])
  end
end
