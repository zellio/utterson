module Lanyon::Route::Files::Post
  def self.registered(app)
    app.post '/files/?' do
      path = request.params[:path]
      content = request.params[:content]

      app.repo_manager.add(path, content)
    end
  end
end
