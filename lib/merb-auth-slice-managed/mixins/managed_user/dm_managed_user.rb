module Merb
  class Authentication
    module Mixins
      module ManagedUser
        module DMClassMethods
          def self.extended(base)
            base.class_eval do
              property :activated_at,    DateTime
              property :activation_code, String

              property :password_reset_at,   DateTime
              property :password_reset_code, String

              property :unlcoked_at,    DateTime
              property :unlock_code, String

              before :create, :make_activation_code
              after  :create, :send_signup_notification
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
