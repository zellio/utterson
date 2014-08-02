module Utterson
  module Route; end

  module Routes
    Dir[::File.join(__dir__, 'route', '*.rb')].each do |file|
      require file
    end

    def self.registered(app)
      Route.constants.each do |const|
        nodule = Utterson::Route.const_get const
        app.register(nodule) if nodule.class == Module
      end
    end
  end
end
