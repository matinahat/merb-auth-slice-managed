module Merb
  class Authentication
    module Mixins
      module ManagedUser
        module ARClassMethods
          def self.extended(base)
            base.class_eval do
              before :create, :make_activation_code
              after  :create, :send_signup_notification
            end # base.class_eval
          
            def find_with_activation_code(ac)
              find(:first, :conditions => ["activation_code =?", ac])
            end
          
            def find_with_password_reset_code(prc)
              find(:first, :conditions => ["password_reset_code =?", prc])
            end
          
            def find_with_unlock_code(uc)
              find(:first, :conditions => ["unlock_code =?", uc])
            end
          
          end # self.extended
        end # ARClassMethods
      end # ActivatedUser
    end # Mixins
  end # Authentication
end # Merb
