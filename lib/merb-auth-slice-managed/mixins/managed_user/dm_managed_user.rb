module Merb
  class Authentication
    module Mixins
      module ManagedUser
        module DMClassMethods
          def self.extended(base)
            base.class_eval do
              include DataMapper::Timestamp

              property :magic_key,          String
              property :crypted_password,   String
              property :salt,               String

              property :username,           String, :nullable => false, :unique => true, :unique_index => :username
              property :email,              String, :nullable => false, :unique => true, :unique_index => true, :format => :email_address
              property :real_name,          String, :nullable => false


              property :logged_in_at,       DateTime
              property :created_at,         DateTime
              property :updated_at,         DateTime

              property :activated_at,    DateTime
              property :activation_code, String

              property :password_reset_at,   DateTime
              property :password_reset_code, String

              property :unlocked_at,    DateTime
              property :unlock_code, String

              # Validations
              validates_present :password, :if => proc{|m| m.password_required?}
              validates_is_confirmed :password, :if => proc{|m| m.password_required?}

              # Filters
              before :create, :make_activation_code
              after  :create, :send_signup_notification
              before :save, :encrypt_password
              before :save, :generate_magic_key

            end # base.class_eval

            def find_with_activation_code(ac)
              first(:activation_code => ac)
            end
          
            def find_with_password_reset_code(prc)
              first(:password_reset_code => prc)
            end
          
            def find_with_unlock_code(uc)
              first(:unlock_code => uc)
            end
          
          end # self.extended
        end # DMClassMethods
      end # ActivatedUser
    end # Mixins
  end # Authentication
end #Merb
