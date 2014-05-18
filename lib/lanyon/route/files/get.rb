module Lanyon::Route::Files::Get
  def self.registered(app)
    app.get '/files', provides: [:json] do
      respond_with :files, files: app.repo_manager.files
    end

    app.get '/files/:oid', provides: [:html, :json]  do
      respond_with :editor, file: app.repo_manager.file(params[:oid])
    end

    app.get '/files/*/?', provides: [:html, :json]  do
      path = params[:splat].first
      respond_with :files, files: app.repo_manager.files.ls(path)
    end
  end
end
