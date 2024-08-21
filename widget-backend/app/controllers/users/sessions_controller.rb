class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    if request.format.json?
      render json: { message: 'Signed in successfully.', user: resource }
    else
      redirect_to after_sign_in_path_for(resource)
    end
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    if request.format.json?
      render json: { message: 'Signed out successfully.' }
    else
      redirect_to after_sign_out_path_for(resource_name)
    end
  end
end
