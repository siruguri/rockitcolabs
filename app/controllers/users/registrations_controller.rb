class Users::RegistrationsController <Devise::RegistrationsController
	def index
		if current_user.user_type=='superadmin'
			@users=User.all
		else
			@users=[current_user]
		end

	end

	def new
		super
	end
	def create
		super
	end

	def edit
		super
	end
	def update
		super
	end

=begin
	
	private
	def user_params
		params[:user].permit(user_events_attributes: [:name, :email, :phone])
	end
	def set_user
		@user=User.find(params[:id])
	end
=end

end
