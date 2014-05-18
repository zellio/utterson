module Lanyon::Route::Files::Put
  def self.registered(app)
    app.put '/files/?' do
      oid = request.params[:oid]
      path = request.params[:path]
      content = request.params[:content]

      file = app.repo_manager.file(oid)

      halt 501 if file.nil?

      app.repo_manager.move(file, path) if path && path != file.path
      app.repo_manager.update(file, content) if content && content != file.content
    end
  end
end
