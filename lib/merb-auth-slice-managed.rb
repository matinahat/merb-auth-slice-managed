if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  require 'merb-slices'
  require 'merb-auth-core'
  require 'merb-auth-more'
  require 'merb-mailer'
  require(File.expand_path(File.dirname(__FILE__) / "merb-auth-slice-managed" / "mixins") / "managed_user")
  
  Merb::Plugins.add_rakefiles "merb-auth-slice-managed/merbtasks", "merb-auth-slice-managed/slicetasks", "merb-auth-slice-managed/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)

  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to
  # the main application layout or no layout at all if needed.
  #
  # Configuration options:
  # :layout - the layout to use; defaults to :merb-auth-slice-activation
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:merb_auth_slice_managed][:layout] ||= :application

  # All Slice code is expected to be namespaced inside a module
  module MerbAuthSliceManaged

    # Slice metadata
    self.description = "MerbAuthSliceManaged is a merb slice that adds basic managable user, eg activation, locking, passwrod reset features to merb-auth-based merb applications."
    self.version = "1.0.8.1"
    self.author = "Daniel Neighman, Christian Kebekus, Tymon Tobolski, Mat Miehle"

    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end

    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
      # Actually check if the user is active 
      ::Merb::Authentication.after_authentication do |user, *rest|
        if user.respond_to?(:active?)
          user.active? ? user : nil
        else 
          user
        end
      end
    end

    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end

    # Deactivation hook - triggered by Merb::Slices.deactivate(MerbAuthSliceManged)
    def self.deactivate
    end

    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :merb_auth_slice_activation_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      scope.match("/activate/:activation_code").to(:controller => "activations", :action => "activate").name(:activate)
      scope.match("/password/reset/:reset_code").to(:controller => "passwords", :action => "reset").name(:reset)
      scope.match("/password/lost").to(:controller => "passwords", :action => "lost").name(:lost)
      scope.match("/password/update").to(:controller => "passwords", :action => "update").name(:pwupdate)
    end

  end

  # Setup the slice layout for MerbAuthSliceManaged
  #
  # Use MerbAuthSliceActivation.push_path and MerbAuthSliceManged.push_app_path
  # to set paths to merb-auth-slice-managed-level and app-level paths. Example:
  #
  # MerbAuthSliceManaged.push_path(:application, MerbAuthSliceManaged.root)
  # MerbAuthSliceManaged.push_app_path(:application, Merb.root / 'slices' / 'merb-auth-slice-managed')
  # ...
  #
  # Any component path that hasn't been set will default to MerbAuthSliceManaged.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MerbAuthSliceManaged.setup_default_structure!
  MaSM = MerbAuthSliceManaged unless defined?(MaSM)

  # Add dependencies for other MerbAuthSliceManaged classes below. Example:
  # dependency "merb-auth-slice-managed/other"

end
