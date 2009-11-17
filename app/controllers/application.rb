class MerbAuthSliceManaged::Application < Merb::Controller
  
  controller_for_slice

  def update_token
    st = SkynetToken.new(@user)

    cookies.set_cookie(Merb::Config[:auth_token_name],
                        "#{st.token}--#{st.key}--#{st.value}", 
                        {:domain => Merb::Config[:cookie_domain]})
        
    session[:user] = @user    
  end
  
end
