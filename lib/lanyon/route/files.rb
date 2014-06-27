module Lanyon::Route::Files
  def self.registered(app)
    # app.repo_manager = Lanyon::RepositoryManager.new(app.repo_dir)

    # CREATE
    app.post '/files/?' do
      path = request.params[:path]
      content = request.params[:content]

      app.repo_manager.add(path, content)
    end

    # READ
    app.get %r{\A/files(?:/(?<path>.*))?\Z}, provides: [:json] do
      obj = app.repo_manager.directory(params[:path]) rescue nil

      halt 404 if obj.nil?

      obj.read

      respond_with :files, files: obj if obj.is_a? Lanyon::Directory
      respond_with :editor, file: obj if obj.is_a? Lanyon::File
    end

    # UPDATE
    app.put '/files/?' do
      oid = request.params[:oid]
      path = request.params[:path]
      content = request.params[:content]

      file = app.repo_manager.file(oid)

      halt 501 if file.nil?

      app.repo_manager.move(file, path) if path && path != file.path
      app.repo_manager.update(file, content) if content && content != file.content
    end

    # DELETE
    app.delete '/files/?' do
      oid = request.params[:oid]

      file = app.repo_manager.file(oid)

      halt 501 if file.nil?

      app.repo_manager.delete(file)
    end
  end
end
