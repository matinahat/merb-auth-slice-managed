module Merb
  class Authentication
    module Mixins
      # This mixin provides basic user management features.
      #
      # Added properties:
      #  :activated_at,    DateTime
      #  :activation_code, String
      #
      # To use it simply require it and include it into your user class.
      #
      # class User
      #   include Authentication::Mixins::ManagedUser
      #
      # end
      #
      module ManagedUser
        def self.included(base)
          base.class_eval do
            include Merb::Authentication::Mixins::ManagedUser::InstanceMethods
            extend  Merb::Authentication::Mixins::ManagedUser::ClassMethods

            path = File.expand_path(File.dirname(__FILE__)) / "managed_user"
            if defined?(DataMapper) && DataMapper::Resource > self
              require path / "dm_managed_user"
              extend(Merb::Authentication::Mixins::ManagedUser::DMClassMethods)
            elsif defined?(ActiveRecord) && ancestors.include?(ActiveRecord::Base)
              require path / "ar_managed_user"
              extend(Merb::Authentication::Mixins::ManagedUser::ARClassMethods)
            elsif defined?(Sequel) && ancestors.include?(Sequel::Model)
              require path / "sq_managed_user"
              extend(Merb::Authentication::Mixins::ManagedUser::SQClassMethods)
            end

          end # base.class_eval
        end # self.included


        module ClassMethods
          # Create random key.
          #
          # ==== Returns
          # String:: The generated key
          def make_key
            Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
          end


          def encrypt(password, salt)
                Digest::SHA1.hexdigest("--#{salt}--#{password}--")
          end

          def authenticate(user, password)
            @u = User.first(:username => user)

            if @u && @u.authenticated?(password)
               @u.update_attributes(:logged_in_at => Time.now)
               @u
            else
              nil
            end
          end

        end # ClassMethods

        module InstanceMethods

          # Activates and saves the user.
          def activate!
            self.reload unless self.new_record? # Make sure the model is up to speed before we try to save it
            set_activated_data!
            self.save

            # send mail for activation
            send_activation_notification
          end

          # Checks if the user has just been activated. Where 'just' means within the current request.
          # Note that a user can be activate, but the method returns +false+!
          #
          # ==== Returns
          # Boolean:: +true+ is the user has been activated, otherwise +false+.
          def recently_activated?
            @activated
          end

          # Checks to see if a user is active
          def active?
            return false if self.new_record?
            !! activation_code.nil?
          end

          alias_method :activated?, :active?

          # Sets an r
          def mark_for_reset!
            self.reload unless self.new_record? # Make sure the model is up to speed before we try to save it
            make_password_reset_code
            self.save

            #send_password_reset_notification
          end

          # Sets an r
          def reset!
            self.reload unless self.new_record? # Make sure the model is up to speed before we try to save it
            self.password_reset_at = DateTime.now
            self.password_reset_code = nil
            self.save

            send_new_password_notification
          end

          # Creates and sets the activation code for the user.
          #
          # ==== Returns
          # String:: The activation code.
          def make_activation_code
            self.activation_code = self.class.make_key
          end

          # Creates and sets the pw reset code for the user.
          #
          # ==== Returns
          # String:: The pw reset code.
          def make_password_reset_code
            self.password_reset_code = self.class.make_key
            self.password_reset_at = Time.now
          end

          # Creates and sets the unlock code for the user.
          #
          # ==== Returns
          # String:: The unlock code.
          def make_unlock_code
            self.unlock_code = self.class.make_key
          end

            def authenticated?(password)
              crypted_password == encrypt(password)
            end

            def encrypt(password)
              self.class.encrypt(password, salt)
            end
                             
            def password_required?
              crypted_password.blank? || !password.blank?
            end
                                      
            def encrypt_password
              return if password.blank?
              self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{username}--") if new_record?
              self.crypted_password = encrypt(password)
            end

            def generate_magic_key
              self.magic_key = Digest::SHA1.hexdigest("--#{email}--#{Time.now.to_s}--")
            end
          

          # Sends out the activation notification.
          # Used 'Welcome' as subject if +MaSM[:activation_subject]+ is not set.
          def send_activation_notification
            deliver_email(:activation, :subject => (MaSM[:welcome_subject] || "Welcome" ))
          end

          # Sends out the signup notification.
          # Used 'Please Activate Your Account' as subject if +MaSM[:activation_subject]+ is not set.
          def send_signup_notification
            deliver_email(:signup, :subject => (MaSM[:activation_subject] || "Please Activate Your Account") )
          end

          # Sends out the password reset notification.
          # Used 'Request to change your password' as subject if +MaSM[:password_reset_subject]+ is not set.
          def send_password_reset_notification
            deliver_email(:password_reset, :subject => (MaSM[:password_reset_subject] || "Request to change your password"))
          end

          # Sends out the password reset notification.
          # Used 'Request to change your password' as subject if +MaSM[:password_reset_subject]+ is not set.
          def send_new_password_notification
            deliver_email(:new_password, :subject => (MaSM[:new_password_subject] || "Your password was successfully changed"))
          end

          # Sends out the password reset notification.
          # Used 'Request to change your password' as subject if +MaSM[:password_reset_subject]+ is not set.
          def send_unlock_notification
            deliver_password_reset_email(:password_reset, :subject => (MaSM[:password_reset_subject] || "Request to change your password"))
          end

          private

          # Helper method delivering the email.
          def deliver_email(action, params)
            from = MaSM[:from_email]
            raise "No :from_email option set for Merb::Slices::config[:merb_auth_slice_managed][:from_email]" unless from
            MaSM::ManagementMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => self.email), :user => self)
          end

          def set_activated_data!
            @activated = true
            self.activated_at = DateTime.now
            self.activation_code = nil
            true
          end
        end # InstanceMethods
      end # ManagedUser
    end # Mixins
  end # Authentication
end # Merb
