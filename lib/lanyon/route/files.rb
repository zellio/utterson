module Lanyon::Route::Files
  def self.registered(app)
    # CREATE
    app.post '/files/?' do
      path = request.params['path']

      file = Lanyon::File.new(path, '', app.repo_manager.repo.workdir)

      halt 405 if file.exists?

      content = request.params['content']

      app.repo_manager.add(file, content)
    end

    # READ
    app.get %r{\A/(?<fn>files|editor)(?:/(?<path>.*))?\Z}, provides: [:html, :json] do
      obj = app.repo_manager.get(params['path']) rescue nil

      halt 404 unless obj

      obj.read

      respond_with params['fn'].to_sym, obj
    end

    # UPDATE
    app.put '/files/?' do
      path = request.params['path']
      file = app.repo_manager.get(path)

      halt 404 unless file && file.exists?

      content = request.params['content']
      dest = request.params['destination']

      halt 405 if app.repo_manager.get(dest)

      app.repo_manager.move(file, dest) if dest && dest != file.path
      app.repo_manager.update(file, content) if content && content != file.content
    end

    # DELETE
    app.delete '/files/?' do
      path = request.params['path']

      file = app.repo_manager.file(path)

      halt 404 if file.nil? || file.oid != request.params['oid']

      app.repo_manager.delete(file)
    end
  end
end
