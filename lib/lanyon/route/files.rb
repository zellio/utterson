require 'rugged'

module Lanyon::Route::Files
  def self.registered(app)
    repo = Rugged::Repository.new(app.repo_dir)

    app.get '/files/*' do
      'Hello world'
    end
  end
end
