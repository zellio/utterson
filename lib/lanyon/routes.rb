module Lanyon
  module Route; end

  module Routes
    Dir[::File.join(__dir__, 'route', '*.rb')].each do |file|
      require file
    end

    def self.registered(app)
      Route.constants.each do |const|
        _module = Lanyon::Route.const_get const
        app.register(_module) if _module.class == Module
      end
    end
  end
end
