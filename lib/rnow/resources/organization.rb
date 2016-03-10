module Rnow
  class Organization < Resource
    remote_attr_accessor  :lookupName,
                          :login

    remote_attr_reader :id, 
                       :createdTime,
                       :updatedTime

    rnow_object "organizations"

    def delete
      raise "Not supported"
    end
    
    def create
      raise "Not supported"
    end

    def modify
      raise "Not supported"
    end
  end
end