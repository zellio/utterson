module Lanyon::Route::Index
  def self.registered(app)
    app.get '/' do
      liquid :index
    end
  end
end
