require 'spec_helper'
class FooResource < Rnow::Resource
  remote_attr_accessor :name, :junction, :extattrs
  remote_attr_writer :do_it
  remote_post_accessor :sect
  remote_attr_reader :readonly_thing
  attr_accessor :animal
  rnow_object "foo:animal"
end

FooResponse = Struct.new(:body)

describe Rnow::Resource do
  it "hashes correctly" do
    host = FooResource.new
    host.href = "123"
    host.animal = "mom"
    host.name = "lol"
    hsh = host.send(:remote_attribute_hash)
    expect(hsh).to eq({:name => 'lol'})
  end  

  it "return fields" do
    hsh = FooResource._return_fields
    expect(hsh).to eq('name,junction,extattrs,readonly_thing')
  end

  it "should have a correct resource_uri" do
    expect(FooResource.resource_uri).to eq(Rnow.base_path + "foo:animal")
    f=FooResource.new
    expect(f.resource_uri).to eq(Rnow.base_path + "foo:animal")
    f.href = "lkjlkj"
    expect(f.resource_uri).to eq(Rnow.base_path + "lkjlkj")
  end

  it "should find with default attributes" do
    conn = double
    uri = Rnow.base_path + "foo:animal"
    allow(conn).to receive(:get).with(uri,{}).and_return(FooResponse.new("{\"items\": []}"))
    expect(FooResource.all(conn)).to eq([])
  end

  it "should allow .all with return fields or max results" do
    conn = double
    uri = Rnow.base_path + "queryResults"
    allow(conn).to receive(:get).with(uri, {:query=>"select%20*%20from%20foo:animal%20limit%2020%20offset%201"}).and_return(FooResponse.new("{\"items\": [{\"columnNames\": {}, \"rows\": {}}]}"))
    expect(FooResource.paginate(conn, {page: 1, count: 20})).to eq([])
  end

  it "should put with the right attributes" do
    conn = double
    uri = Rnow.base_path + "abcd"
    allow(conn).to receive(:put).with(uri, {:name => "jerry", :junction => "32", :do_it => false}).and_return(FooResponse.new("{\"links\": [{\"href\": \"acme.com\"}]}"))
    f = FooResource.new(:connection => conn)
    f.href = "abcd" 
    f.do_it = false
    f.junction = "32"
    f.name = "jerry"
    f.sect = :fulburns
    f.put
    expect(f.href).to eq("acme.com")
  end

  it "should post with the right attributes" do
    conn = double
    uri = Rnow.base_path + "foo:animal"
    allow(conn).to receive(:post).with(uri, {:name => "jerry", :junction => "32", :do_it => false, :sect => :fulburns}).and_return(FooResponse.new("{\"links\": [{\"href\": \"acme.com\"}]}"))
    f = FooResource.new(:connection => conn)
    f.do_it = false
    f.junction = "32"
    f.name = "jerry"
    f.sect = :fulburns
    f.post
    expect(f.href).to eq('acme.com')
  end

  it 'should set all attributes including readonly attrs' do
    f = FooResource.new(:readonly_thing => 45, :do_it => false, :sect => :larry)
    expect(f.readonly_thing).to eq(45)
    expect(f.do_it).to be(false)
    expect(f.sect).to eq(:larry)
  end
  
  it 'should load attributes on get' do
    conn     = double
    uri      = Rnow.base_path + "a:ref:that:is:fake"
    json     = {:name => "john", :junction => "hi", :extattrs => {"foo" => 3}}.to_json
    response = FooResponse.new(json)
    expect(conn).to receive(:get).with(uri, FooResource.default_params).and_return(response)
    f        = FooResource.new(:connection => conn, :href => "a:ref:that:is:fake")
    f.get
    expect(f.name).to eq("john")
    expect(f.junction).to eq("hi")
    expect(f.extattrs).to eq({"foo" => 3})
  end

  it 'should map wapi objects to classes' do
    @expected = {}
    ObjectSpace.each_object(Class) do |p|
      if p < Rnow::Resource
        @expected[p.rnow_object] = p
      end
    end
    expect(Rnow::Resource.resource_map).to eq(@expected)
  end
end

