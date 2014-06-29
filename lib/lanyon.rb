require 'ruby/kernel' unless Kernel.method_defined?('__dir__')
require 'ruby/hash' unless Hash.method_defined?('to_h')

module Lanyon
  require 'lanyon/version'
  require 'lanyon/file_object'
  require 'lanyon/file'
  require 'lanyon/directory'
  require 'lanyon/repository_manager'
  require 'lanyon/routes'
  require 'lanyon/application'
end
