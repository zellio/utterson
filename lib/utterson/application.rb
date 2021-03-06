require 'multi_json'
require 'sinatra/base'
require 'sinatra/config_file'
require 'sinatra/respond_with'
require 'rack/coffee'
require 'rack/parser'
require 'sass/plugin/rack'

class Utterson::Application < Sinatra::Base
  set :project_root, -> { File.join(__dir__, '..', '..') }
  set :root, -> { __dir__ }
  set :views, -> { File.join(root, 'templates') }
  set :public_folder, -> { File.join(root, 'assets') }
  set :repo_manager, -> { Utterson::RepositoryManager.new(repo_dir) }

  register Sinatra::ConfigFile
  config_file ['config.yml', File.join(project_root, 'config.yml')]

  set :erb, layout: :base
  set :erb, trim: '-'

  Sass::Plugin.options.merge!(
    style: :expanded,
    template_location: {
      File.join(public_folder, 'sass') => File.join(public_folder, 'css')
    }
  )
  use Sass::Plugin::Rack

  use Rack::Coffee, root: public_folder, urls: '/js'

  use Rack::Parser, parsers: {
    /json/ => proc { |body| ::MultiJson.decode(body) }
  }

  register Sinatra::RespondWith

  register Utterson::Routes
end
