require 'sinatra/base'
require 'sinatra/config_file'
require 'liquid'
require 'sass/plugin/rack'
require 'rack/coffee'

class Lanyon::Application < Sinatra::Base
  set :root, -> { __dir__ }
  set :views, -> { File.join(root, 'templates') }
  set :public_folder, -> { File.join(root, 'assets') }

  register Sinatra::ConfigFile
  config_file 'config.yml'

  Liquid::Template.file_system = Liquid::LocalFileSystem.new(views)
  set :liquid, layout: :base

  Sass::Plugin.options.merge!(
    style: :expanded,
    template_location: {
      File.join(public_folder, "sass") => File.join(public_folder, "css")
    }
  )
  use Sass::Plugin::Rack

  use Rack::Coffee, root: public_folder, urls: '/js'

  register Lanyon::Routes
end
