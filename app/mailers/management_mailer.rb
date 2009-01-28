class MerbAuthSliceManaged::ManagementMailer < Merb::MailController
  include Merb::MerbAuthSliceManaged::MailerHelper
  
  controller_for_slice MerbAuthSliceManaged, :templates_for => :mailer, :path => "views"

  def signup
    @user = params[:user]
    Merb.logger.info "Sending Signup to #{@user.email} with code #{@user.activation_code}"
    render_mail :layout => nil
  end

  def activation
    @user = params[:user]
    Merb.logger.info "Sending Activation email to #{@user.email}"
    render_mail :layout => nil
  end

  def password_reset
    @user = params[:user]
    Merb.logger.info "Sending password reset to #{@user.email} with code #{@user.password_reset_code}"
    render_mail :layout => nil
  end

  def new_password
    @user = params[:user]
    Merb.logger.info "Sending new password notification to #{@user.email}"
    render_mail :layout => nil
  end

  def unlock
    @user = params[:user]
    Merb.logger.info "Sending unlock notification to #{@user.email}"
    render_mail :layout => nil
  end
end
