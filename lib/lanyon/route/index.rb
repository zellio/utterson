module Lanyon::Route::Index
  def self.registered(app)
    require 'lanyon/route/index/get'

    app.register(Lanyon::Route::Index::Get)
  end
end
