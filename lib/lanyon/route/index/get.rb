module Lanyon::Route::Index::Get
  def self.registered(app)
    app.get '/' do
      liquid :index
    end
  end
end
