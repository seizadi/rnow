require 'spec_helper'
describe Rnow::Connection do

  ["test.acme.com", "116.136.168.68", "http://test.acme.com:3000", "https://test.acme.com"].each do |host|
    it "should build URL #{host} without failure" do
      conn_params = {
        :username => "soheil",
        :password => "password",
        :host =>     host
      }
      uri = "services/rest/connect"

      ic = Rnow::Connection.new(conn_params)
      ic.adapter       = :test
      ic.adapter_block = stub_get(uri)

      # execute the request. There should be no "URI::BadURIError: both URI are relative" error
      ic.get(uri)
    end
  end

  it "should raise authentication error response" do
    host        = 'test.acme.com'
    conn_params = {
      :username => "soheil",
      :password => "password",
      :host =>     host
    }
    uri         = "/wapi/v1.0/record:host"

    ic               = Rnow::Connection.new(conn_params)
    ic.adapter       = :test
    ic.adapter_block = stub_get(uri, 404)

    # execute the request. There should be no "URI::BadURIError: both URI are relative" error

    expect { ic.get(uri) }.to raise_error(Rnow::Error)
  end

  def stub_get(uri, status=200)
    Proc.new do |stub|
      stub.get(uri) { [ status, {}, 'SUCCESS'] }
    end
  end
end
