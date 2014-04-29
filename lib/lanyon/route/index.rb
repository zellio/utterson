module Lanyon::Route::Index
  def self.registered(app)
    app.get '/' do
      liquid :index, locals: { title: 'Lanyon' }
    end
  end
end
