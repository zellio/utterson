module Lanyon::Route::Files
  def self.registered(app)
    require 'lanyon/route/files/post'
    require 'lanyon/route/files/get'
    require 'lanyon/route/files/put'
    require 'lanyon/route/files/delete'

    app.register(Lanyon::Route::Files::Post)
    app.register(Lanyon::Route::Files::Get)
    app.register(Lanyon::Route::Files::Put)
    app.register(Lanyon::Route::Files::Delete)
  end
end
