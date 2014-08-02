module Utterson::Route::Index
  def self.registered(app)
    app.get '/' do
      erb :index, locals: { title: '' }
    end
  end
end
