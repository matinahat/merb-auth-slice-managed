class MerbAuthSliceManaged::Activations <  MerbAuthSliceManaged::Application

  private
  def redirect_after_activation
    redirect url(:home), :message => {:notice => "Activation Successful"}
  end

end # MerbAuthSliceManaged::Activations
