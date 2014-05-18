module Lanyon::Route::Files::Delete
  def self.registered(app)
    app.delete '/files/?' do
      oid = request.params[:oid]

      file = repo_manager.file(oid)

      halt 501 if file.nil?

      repo_manager.delete(file)
    end
  end
end
