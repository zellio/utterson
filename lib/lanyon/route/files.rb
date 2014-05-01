require 'rugged'

module Lanyon::Route::Files
  def self.registered(app)
    repo = Rugged::Repository.new(app.repo_dir)

    # CREATE
    app.post '/files' do
    end

    # READ
    app.get '/files/*/?:id?', provides: [:html, :json] do
      path = "./#{params[:splat].first}"
      oid = params[:id]

      respond_with :files, files: nil
    end

    # UPDATE
    app.put '/files' do
    end

    # DELETE
    app.delete '/files' do
    end
  end
end
