# Rails.application.assets.register_engine '.haml', Tilt::HamlTemplate

# Rails.application.assets.register_engine '.slim', Slim::Template

Slim::Engine.set_default_options attr_delims: { '(' => ')', '[' => ']' }

