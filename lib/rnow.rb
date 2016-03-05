require 'logger'
require 'json'
require 'faraday'
require 'faraday_middleware'
require 'openssl'
require "rnow/version"
require "rnow/connection"

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
  	'services/rest/connect/v' + Infoblox.wapi_version + '/'
  end
  module_function :base_path
end
