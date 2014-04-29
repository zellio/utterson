require 'sinatra/base'
require 'sinatra/config_file'
require 'liquid'

class Lanyon::Application < Sinatra::Base
  set :root, -> { __dir__ }
  set :views, -> { File.join(root, 'templates') }
  set :public_folder, -> { File.join(root, 'assets') }

  Liquid::Template.file_system = Liquid::LocalFileSystem.new(views)
  set :liquid, layout: :base

  register Sinatra::ConfigFile
  config_file 'config.yml'

  register Lanyon::Routes
end
