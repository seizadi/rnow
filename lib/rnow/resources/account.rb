module Rnow
  class Account < Resource
    remote_attr_accessor  :login,
                          :lookupName

    remote_attr_reader :id, 
                       :createdTime,
                       :updatedTime

    rnow_object "accounts"

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