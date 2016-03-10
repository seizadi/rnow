module Rnow
  class Category < Resource
    remote_attr_accessor :lookupName

    remote_attr_reader :id, 
                       :createdTime,
                       :updatedTime

    rnow_object "serviceCategories"

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
