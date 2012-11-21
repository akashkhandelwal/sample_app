class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by_email(params[:email].downcase) # if using "form_for" tag in "new.html.erb", use
																											 # User.find_by_email(params[:session][:email].downcase)
		if user && user.authenticate(params[:password])
			if user.confirmed == true
				sign_in user
				redirect_back_or user
			else
				send_confirmation_mail(user)
			end
		else
			flash.now[:error] = 'Invalid email/password combination'
      render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end