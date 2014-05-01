require 'rugged'

module Lanyon::Route::Files
  def self.registered(app)
    repo = Rugged::Repository.new(app.repo_dir)

    app.get '/files/*', provides: [:html, :json] do
      respond_with :files, files: nil
    end
  end
end
