module Rnow
  class Contact < Resource
    remote_attr_accessor  :login,
                          :lookupName,
                          :organization
                       
    remote_attr_reader  :id, 
                        :createdTime,
                        :updatedTime

    rnow_object "contacts"

    def delete
      raise "Not supported"
    end

    def modify
      raise "Not supported"
    end
  end
end