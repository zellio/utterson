require 'ruby/kernel' unless Kernel.method_defined?('__dir__')
require 'ruby/hash' unless Hash.method_defined?('to_h')

module Utterson
  require 'utterson/version'
  require 'utterson/conversion'
  require 'utterson/file_object'
  require 'utterson/file'
  require 'utterson/directory'
  require 'utterson/repository_manager'
  require 'utterson/routes'
  require 'utterson/application'
end
