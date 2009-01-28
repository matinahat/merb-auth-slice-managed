class MerbAuthSliceManaged::Passwords <  MerbAuthSliceManaged::Application

  after :redirect_after_update, :only => [:update]

  def reset
    session.user = Merb::Authentication.user_class.find_with_password_reset_code(params[:reset_code])
    raise NotFound if session.user.nil?

    @user = session.user

    session.user = nil
    session[:user] = nil
    session[:pwru] = @user

    render( {:template => "users/password"} )
  end

  def update
    raise NotFound if session[:pwru].nil?

    @user = session[:pwru]

    session[:user] = nil
    session[:pwru] = nil

    params[:user][:password_reset_code] = nil
    params[:user][:password_reset_at] = Time.now
    raise BadRequest unless @user.update_attributes(params[:user])

    @user.send_new_password_notification
    
    @user = nil

    ""
  end

  def lost
    if params[:email]
  
      @user = User.first(:email => params[:email])

      if @user
        @user.mark_for_reset!
        @user.send_password_reset_notification
      end

      render( {:template => "users/reset"} )
    else
      render( {:template => "users/lost"} )
    end
  end

  private
  def redirect_after_update
    redirect "/", :message => {:notice => "Password changed successfully"}
  end

end # MerbAuthSliceManaged::Passwords
