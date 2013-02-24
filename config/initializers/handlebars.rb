env = Sprockets::Environment.new

require 'handlebars_assets'
env.append_path HandlebarsAssets.path
HandlebarsAssets::Config.template_namespace = 'JST'
