class MerbAuthSliceManaged::Activations <  MerbAuthSliceManaged::Application

  private
  def redirect_after_activation
    redirect "/", :message => {:notice => "Activation Successful"}
  end

end # MerbAuthSliceManaged::Activations
