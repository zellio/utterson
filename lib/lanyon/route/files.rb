require 'rugged'

module Lanyon::Route::Files
  def self.registered(app)
    repo = Rugged::Repository.new(app.repo_dir)
    fc = Lanyon::FileCollection.new(repo.index)

    # CREATE
    app.post '/files' do
    end

    # READ
    app.get '/files/*/?:id?', provides: [:html, :json] do
      respond_with :editor, file: fc.get(params[:id]) unless params[:id].nil?

      path = params[:splat].first
      path = path.empty? ? '.' : File.join('.', path)

      respond_with :files, files: fc.ls(path)
    end

    # UPDATE
    app.put '/files' do
    end

    # DELETE
    app.delete '/files' do
    end
  end
end
