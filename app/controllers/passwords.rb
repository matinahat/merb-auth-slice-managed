class MerbAuthSliceManaged::Passwords <  MerbAuthSliceManaged::Application

  def reset
    session.user = Merb::Authentication.user_class.find_with_password_reset_code(params[:reset_code])

    if session.user.nil?
      request.session.authentication.errors.clear!
      request.session.authentication.errors.add("pwreset", "sorry, there was something wrong, generate another")

      render( {:template => "users/lost"} )
    else
      @user = session.user

      session.user = nil
      session[:user] = nil
      session[:pwru] = @user

      render( {:template => "users/password"} )
    end
  end

  def update
    if session[:pwru].nil?
      request.session.authentication.errors.clear!
      request.session.authentication.errors.add("pwreset", "sorry, there was something wrong, generate another")

      render( {:template => "users/lost"} )
    else
      @user = session[:pwru]

      params[:user][:password_reset_code] = nil
      params[:user][:password_reset_at] = Time.now

      if @user.update_attributes(params[:user])
        @user.send_new_password_notification
        @user = nil
        session[:user] = @user
        session[:pwru] = nil
        redirect "/", :message => {:notice => "Password changed successfully"}
      else
        request.session.authentication.errors.clear!
        request.session.authentication.errors.add("pwreset", "sorry, there was something wrong")
        render( {:template => "users/password"} )
      end
    end
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
      #render( {:template => "users/lost"} )
      render
    end
  end
end # MerbAuthSliceManaged::Passwords
