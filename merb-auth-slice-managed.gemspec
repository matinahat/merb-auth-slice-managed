# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{merb-auth-slice-managed}
  s.version = "1.0.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Neighman, Christian Kebekus, Tymon Tobolski, Mat Miehle"]
  s.date = %q{2009-01-26}
  s.description = %q{Merb Slice that bundles activation, password reset, and adds lockable user functionality to merb-auth.}
  s.email = %q{mat@miehle.org}
  s.extra_rdoc_files = ["README.textile", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README.textile", "Rakefile", "TODO", "lib/merb-auth-slice-managed.rb", "lib/merb-auth-slice-managed", "lib/merb-auth-slice-managed/merbtasks.rb", "lib/merb-auth-slice-managed/mixins", "lib/merb-auth-slice-managed/mixins/managed_user.rb", "lib/merb-auth-slice-managed/mixins/managed_user", "lib/merb-auth-slice-managed/mixins/managed_user/dm_managed_user.rb", "lib/merb-auth-slice-managed/mixins/managed_user/sq_managed_user.rb", "lib/merb-auth-slice-managed/mixins/managed_user/ar_managed_user.rb", "lib/merb-auth-slice-managed/slicetasks.rb", "lib/merb-auth-slice-managed/spectasks.rb", "spec/controllers", "spec/controllers/activations_spec.rb", "spec/mailers", "spec/mailers/management_mailer_spec.rb", "spec/mixins", "spec/mixins/managed_user_spec.rb", "spec/spec_helper.rb", "app/controllers", "app/controllers/activations.rb", "app/controllers/application.rb", "app/controllers/passwords.rb", "app/helpers", "app/helpers/application_helper.rb", "app/helpers/mailer_helper.rb", "app/mailers", "app/mailers/management_mailer.rb", "app/mailers/views", "app/mailers/views/management_mailer", "app/mailers/views/management_mailer/activation.text.erb", "app/mailers/views/management_mailer/signup.text.erb", "app/mailers/views/management_mailer/password_reset.text.erb", "app/views", "public/javascripts", "public/javascripts/master.js", "public/stylesheets", "public/stylesheets/master.css", "stubs/app", "stubs/app/controllers", "stubs/app/controllers/activations.rb", "stubs/app/mailers", "stubs/app/mailers/views", "stubs/app/mailers/views/management_mailer", "stubs/app/mailers/views/management_mailer/activation.text.erb", "stubs/app/mailers/views/management_mailer/signup.text.erb"]
  s.has_rdoc = true
  s.homepage = %q{http://merbivore.com/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{merb}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Merb Slice that bundles activation, password reset, and adds lockable user functionality to merb-auth.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<merb-slices>, [">= 1.0"])
      s.add_runtime_dependency(%q<merb-auth-core>, [">= 1.0"])
      s.add_runtime_dependency(%q<merb-auth-more>, [">= 1.0"])
      s.add_runtime_dependency(%q<merb-mailer>, [">= 1.0"])
    else
      s.add_dependency(%q<merb-slices>, [">= 1.0"])
      s.add_dependency(%q<merb-auth-core>, [">= 1.0"])
      s.add_dependency(%q<merb-auth-more>, [">= 1.0"])
      s.add_dependency(%q<merb-mailer>, [">= 1.0"])
    end
  else
    s.add_dependency(%q<merb-slices>, [">= 1.0"])
    s.add_dependency(%q<merb-auth-core>, [">= 1.0"])
    s.add_dependency(%q<merb-auth-more>, [">= 1.0"])
    s.add_dependency(%q<merb-mailer>, [">= 1.0"])
  end
end
