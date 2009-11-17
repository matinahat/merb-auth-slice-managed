class MerbAuthSliceManaged::Users <  MerbAuthSliceManaged::Application
  def new
    @user = User.new
    render
  end

  def edit
    @user = session[:user]

    if @user.id.to_s == params[:id]
      render
    else
      raise BadRequest
    end
  end

  def create
    raise BadRequest unless params[:user]
    
    @user = User.new(params[:user])

    if @user.save
      render
    else
      message[:error] = "Sorry, there was an error"
      render :new
    end
  end

  def update
    raise BadRequest unless session[:user].id.to_s == params[:id]
    
    @user = User.get(params[:id])
     if @user.update(params[:user])
       redirect url(:user, @user)
     else
       raise BadRequest
     end
  end

  def destroy
    @user = session[:user]

    if @user.id.to_s == params[:id] && @user.destroy
      redirect url(:user)
    else
      #raise BadRequest
      "we're not quite ready to destroy you yet. try again later!"
    end
  end

  def lost
    if params[:email]
  
      @user = User.first(:email => params[:email])

      if @user
        @user.send_lost_username_notification
      end

      render :sent
    else
      render
    end
  end

end
