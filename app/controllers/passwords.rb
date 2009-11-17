class MerbAuthSliceManaged::Passwords <  MerbAuthSliceManaged::Application

  def reset
    @pagetitle = "Password reset"
    
    session.user = Merb::Authentication.user_class.find_with_password_reset_code(params[:reset_code])

    if session.user.nil?
      request.session.authentication.errors.clear!
      request.session.authentication.errors.add("pwreset", "sorry, there was something wrong, generate another")

      render :lost
    else
      @user = session.user

      session.user = nil
      session[:user] = nil
      session[:pwru] = @user

      render :password
    end
  end

  def update
    @pagetitle = "Password reset"
    
    if session[:pwru].nil?
      request.session.authentication.errors.clear!
      request.session.authentication.errors.add("pwreset", "sorry, there was something wrong, generate another")

      render :lost
    else
      @user = session[:pwru]

      params[:user][:password_reset_code] = nil
      params[:user][:password_reset_at] = Time.now

      if @user.update(params[:user])
        @user.send_new_password_notification
        @user = nil
        session[:user] = @user
        session[:pwru] = nil
        redirect url(:home), :message => {:notice => "Password reset. Please log in with your username and new password"}
      else
        request.session.authentication.errors.clear!
        request.session.authentication.errors.add("pwreset", "sorry, there was something wrong")
        render :password
      end
    end
  end

  def lost
    @pagetitle = "Lost password"
    
    if params[:email]
  
      @user = User.first(:email => params[:email])

      if @user
        @user.mark_for_reset!
        @user.send_password_reset_notification
      end

      render :reset
    else
      render
    end
  end
end # MerbAuthSliceManaged::Passwords
