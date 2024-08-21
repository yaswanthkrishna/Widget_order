class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_to do |format|
          format.html { redirect_to after_sign_up_path_for(resource) }
          format.json { render json: { message: 'Signed up successfully.', user: resource } }
        end
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_to do |format|
          format.html { redirect_to after_inactive_sign_up_path_for(resource) }
          format.json { render json: { message: "Signed up but inactive.", user: resource } }
        end
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  protected

  def after_sign_up_path_for(resource)
    new_order_path
  end

  def after_inactive_sign_up_path_for(resource)
    new_order_path
  end
end
