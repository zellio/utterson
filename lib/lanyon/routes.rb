require 'pathname'

module Lanyon
  module Route
    VERBS = ['get', 'post', 'put', 'delete']

    def registered(app)
      klass_path = self.name.downcase.gsub('::', ::File::SEPARATOR)
      klass_pathname = Pathname.new(::File.join(__dir__, '..', klass_path))

      VERBS.each do |verb|
        verb_pathname = klass_pathname + verb
        eval(::File.read(verb_pathname.to_s)) if verb_pathname.exist?
      end
    end
  end

  module Routes
    def self.registered(app)
      Dir[::File.join(__dir__, 'route', '*')].each do |directory|
        path = Pathname.new(directory)
        rel = path.relative_path_from(Pathname.new(app.project_root) + 'lib')

        module_array = rel.each_filename.map(&:capitalize)
        route_module = Module.new
        route_module.extend(Route)

        Route.const_set(module_array.last, route_module)
      end

      Route.constants.each do |const|
        nodule = Route.const_get const
        app.register(nodule) if nodule.class == Module
      end
    end
  end
end
