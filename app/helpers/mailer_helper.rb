module Merb
  module MerbAuthSliceManaged
    module MailerHelper

      # Generate the user activation URL
      def activation_url(user)
        setup(user)
        "#{@protocol}://#{@host}#{slice_url(:activate, :activation_code => user.activation_code)}"
      end

      # Generate the user password reset URL
      def reset_url(user)
        setup(user)
        "#{@protocol}://#{@host}#{slice_url(:reset, :reset_code => user.password_reset_code)}"
      end

      # Generate the user unlock reset URL
      def unlock_url(user)
        setup(user)
        "#{@protocol}://#{@host}#{slice_url(:reset, :reset_code => user.password_unlock_code)}"
      end

      # Set up some common stuff
      def setup(user)
        @host      ||= MaSM[:host] || MaSM[:default_host]
        @protocol  ||= MaSM[:protocol] || "http"

        if base_controller # Rendering from a web controller
          @host      ||= base_controller.request.host
          @protocol  ||= "http"
        end

        @host ||= case @host
        when Proc
          @host.call(user)
        when String
          @host
        end

        raise  "There is no host set for the activation email. Set Merb::Slices::config[:merb_auth_slice_managed][:host]" unless @host

      end

    end # MailerHelper
  end # MerbAuthSliceManaged
end # Merb
