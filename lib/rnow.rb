require 'logger'
require 'json'
require 'faraday'
require 'faraday_middleware'
require 'openssl'
require "rnow/version"
require "rnow/connection"
require "rnow/resource"
# Require everything in the resources directory
Dir[File.expand_path('../rnow/resources/*.rb', __FILE__)].each do |f|
  require f
end

module Rnow
  DEBUG        = ENV['DEBUG']
  
  def rnow_version
    @rnow_version ||= (ENV['RNOW_VERSION'] || '1.3')
  end
  module_function :rnow_version

  def rnow_version=(v)
    @rnow_version = v
  end
  module_function :rnow_version=
  
  def base_path
  	'services/rest/connect/v' + Rnow.rnow_version + '/'
  end
  module_function :base_path
end
