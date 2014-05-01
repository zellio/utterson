require 'sinatra/base'
require 'sinatra/config_file'
require 'liquid'
require 'sass/plugin/rack'

class Lanyon::Application < Sinatra::Base
  set :root, -> { __dir__ }
  set :views, -> { File.join(root, 'templates') }
  set :public_folder, -> { File.join(root, 'assets') }

  Liquid::Template.file_system = Liquid::LocalFileSystem.new(views)
  set :liquid, layout: :base

  register Sinatra::ConfigFile
  config_file 'config.yml'

  Sass::Plugin.options.merge!(
    style: :expanded,
    template_location: {
      File.join(public_folder, "sass") => File.join(public_folder, "css")
    }
  )
  use Sass::Plugin::Rack

  register Lanyon::Routes
end
