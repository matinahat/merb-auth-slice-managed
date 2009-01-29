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
    @user = User.new(params[:user])

    if @user.save
      render
    else
      message[:error] = "Sorry, there was an error"
      render :new
    end
  end

  def update
    @user = User.get(params[:id])
     if @user.update_attributes(params[:user])
       redirect url(:user, @user)
     else
       raise BadRequest
     end
  end

  def delete
    @user = session[:user]

    if @user.id.to_s == params[:id] && @user.destroy
      redirect url(:user)
    else
      #raise BadRequest
      "we're not quite ready to destroy you yet. try again later!"
    end
  end
end
