require 'sinatra/base'
require 'sinatra/config_file'

class Lanyon::Application < Sinatra::Base
  set :root, -> { __dir__ }
  set :views, -> { File.join(root, 'templates') }
  set :public_folder, -> { File.join(root, 'assets') }

  register Sinatra::ConfigFile
  config_file 'config.yml'
end
