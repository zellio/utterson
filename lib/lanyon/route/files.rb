module Lanyon::Route::Files
  def self.registered(app)
    rm = Lanyon::RepositoryManager.new(app.repo_dir)

    # CREATE
    app.post '/files/?' do
      path = request.params[:path]
      content = request.params[:content]

    end

    # READ
    app.get '/files', provides: [:json] do
       respond_with :files, files: rm.files
    end

    app.get '/files/*/?:id?', provides: [:html, :json] do
      respond_with :editor, file: rm.file(params[:id]) unless params[:id].nil?

      path = params[:splat].first
      path = path.empty? ? '.' : File.join('.', path)

      respond_with :files, files: rm.files.ls(path)
    end

    # UPDATE
    app.put '/files/?' do
      oid = request.params[:oid]
      path = request.params[:path]
      basename = request.params[:basename]
      dirname = request.params[:dirname]
      content = request.params[:content]

      file = rm.file(oid)

      halt 501 if oid.nil? || file.nil?

      if path.nil?
        path = if dirname && basename
                 File.join(dirname, basename)
               elsif dirname && basename.nil?
                 File.join(dirname, file.basename)
               elsif dirname.nil? && basename
                 File.join(file.dirname, basename)
               end
      end

      rm.move(file, path) if path && path != file.path
      rm.update(file, content) if content && content != file.content
    end

    # DELETE
    app.delete '/files/?' do
      oid = request.params[:oid]

      file = rm.file(oid)

      halt 501 if oid.nil? || file.nil?

      rm.delete(file)
    end
  end
end
