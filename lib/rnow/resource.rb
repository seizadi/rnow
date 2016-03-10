module Rnow
  class Resource
    attr_accessor :href, :connection

    def self.rnow_object(obj=nil)
      if obj.nil? 
        @rnow_object
      else
        self.resource_map[obj] = self
        @rnow_object = obj
      end
    end

    ## 
    # Define a writeable remote attribute, i.e. one that 
    # should show up in post / put operations.
    # 
    def self.remote_attr_accessor(*args)
      args.each do |a|
        attr_accessor a
        remote_attrs << a
      end
    end

    ##
    # Define a remote attribute that can only be sent during a
    # POST operation. 
    # 
    def self.remote_post_accessor(*args)
      args.each do |a|
        attr_accessor a
        remote_post_attrs << a
      end
    end

    ##
    # Define a remote attribute that is write-only
    # 
    def self.remote_attr_writer(*args)
      args.each do |a|
        attr_accessor a
        remote_write_only_attrs << a
      end
    end

    ##
    # Define a read-only attribute
    #
    def self.remote_attr_reader(*args)
      args.each do |a|
        attr_reader a
        remote_read_only_attrs << a
      end
    end

    def self.remote_attrs
      @remote_attrs ||= []
    end

    def self.remote_write_only_attrs
      @remote_write_only_attrs ||= []
    end

    def self.remote_read_only_attrs
      @remote_read_only_attrs ||= []
    end

    def self.remote_post_attrs
      @remote_post_attrs ||= []
    end

    def self._return_fields
      (self.remote_attrs + self.remote_read_only_attrs).join(",")
    end

    def self.default_params
      {:_return_fields => self._return_fields}
    end

    ##
    # Return an array of all records for this resource.
    # There is a limit to about 1000 records that are returned here, so
    # if your resource has more you will need to use paging or search to
    # retreive what you need.
    # See self.paginate() for paganition, see self.find() for search support.
    #
    def self.all(connection, params = {})
      JSON.parse(connection.get(resource_uri, params).body)["items"].map do |item|
        debugger
        href = item.delete("links").first["href"]
        new(item.merge({href: href, connection: connection}))
      end
    end

    ##
    # Return an array of paged records for this resource.
    # The page number from 0-N can be specified
    # The count is the number of entries returned per page
    #
    def self.paginate(connection, params = {page: 0, count: 10})
      page = params.delete(:page)
      count = params.delete(:count)
      uri = Rnow.base_path + 'queryResults';
      params = {query: URI.escape("select * from #{self.rnow_object} limit #{count} offset #{page}")}
      response = JSON.parse(connection.get(uri, params).body)
      keys = response["items"].first["columnNames"]
      rows = response["items"].first["rows"]
      resources=[]
      rows.each do |row|
        hash = Hash[keys.zip row]
        resources << new(hash.merge({href: resource_uri + '/' + hash["id"], connection: connection}))
      end
      resources
    end

    ##
    # Find resources with query by key value pair
    # Typical query patter is:
    # uri = services/rest/connect/latest/contacts?q=lookupName='Soheil Eizadi'
    #
    # Example: Rnow::Contact.find(connection, "lookupName", "Soheil Eizadi")
    #
    def self.find(connection, params = {key: nil, value: nil})
      key = params.delete(:key)
      value = params.delete(:value)
      search = (value.is_a? Integer) ? value : "'#{value}'"
      JSON.parse(connection.get(resource_uri, {q: "#{key}=#{search}"}).body)["items"].map do |item|
        href = item.delete("links").first["href"]
        new(item.merge({href: href, connection: connection}))
      end
    end

    ##
    # Find resoures with ROQL using where clause
    #
    def self.find_where(connection, params = {key: nil, value: nil, count: 10})
      key = params.delete(:key)
      value = params.delete(:value)
      page = params.delete(:page)
      count = params.delete(:count)
      uri = Rnow.base_path + 'queryResults';
      search = (value.is_a? Integer) ? value : "'#{value}'"
      params = {query: URI.escape("select * from #{self.rnow_object} where #{key}=#{search}")}
      response = JSON.parse(connection.get(uri, params).body)
      keys = response["items"].first["columnNames"]
      rows = response["items"].first["rows"]
      resources=[]
      rows.each do |row|
        hash = Hash[keys.zip row]
        resources << new(hash.merge({href: resource_uri + '/' + hash["id"], connection: connection}))
      end
      resources
    end

    ##
    # Filter resources with query by key value pair
    # Typical query patter is:
    # uri = "services/rest/connect/latest/contacts?q=lookupName like '%Soheil%'"
    #
    # Example: Rnow::Contact.filter(connection, "lookupName", "Soheil Eizadi")
    #
    def self.filter(connection, params = {key: nil, value: nil})
      key = params.delete(:key)
      value = params.delete(:value)
      JSON.parse(connection.get(resource_uri, {q: "#{key} like '%#{value}%'"}).body)["items"].map do |item|
        href = item.fetch("links").first["href"]
        new(item.merge({href: href, connection: connection}))
      end
    end

    def self.resource_uri
      Rnow.base_path + self.rnow_object
    end

    ##
    # A hash that maps Rnow WAPI object identifiers to subclasses of Resource.
    # Used by the Search resource for mapping response objects.
    #
    def self.resource_map
      @@resource_map ||= {}
    end

    def initialize(attrs={})
      load_attributes(attrs)
    end

    def post
      resource = JSON.parse(connection.post(resource_uri, remote_attribute_hash(write = true, post = true)).body)
      self.href = resource.fetch("links").first["href"]
      true
    end
    alias_method :create, :post

    def delete
      connection.delete(resource_uri).status == 200
    end

    def get(params=self.class.default_params)
      response = connection.get(resource_uri, params).body
      load_attributes(JSON.parse(response))
      self
    end

    def put
      resource = JSON.parse(connection.put(resource_uri, remote_attribute_hash(write = true)).body)
      self.href = resource.fetch("links").first["href"]
      true
    end

    def resource_uri
      self.href.nil? ? self.class.resource_uri : (Rnow.base_path + self.href)
    end
    
    def remote_attribute_hash(write=false, post=false)
      {}.tap do |hsh|
        self.class.remote_attrs.each do |k|
          hsh[k] = self.send(k) unless self.send(k).nil?
        end
        self.class.remote_write_only_attrs.each do |k|
          hsh[k] = self.send(k) unless self.send(k).nil?
        end if write
        self.class.remote_post_attrs.each do |k|
          hsh[k] = self.send(k) unless self.send(k).nil?
        end if post
      end
    end

  private

    def load_attributes(attrs)
      attrs.each do |k,v|
        # Some things have specialized writers
        if respond_to?("#{k}=")
          send("#{k}=", v)
        
        # Some things don't have writers (i.e. remote_attr_reader fields)
        else
          instance_variable_set("@#{k}", v)
        end
      end
    end
  end

end
