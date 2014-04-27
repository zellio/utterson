require 'sinatra/base'

class Lanyon::Application < Sinatra::Base
  set :root, -> { __dir__ }
  set :views, -> { File.join(root, 'templates') }
  set :public_folder, -> { File.join(root, 'assets') }
end
