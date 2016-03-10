module Rnow
  class Incident < Resource
    remote_attr_accessor	:lookupName, 
                       		:subject,
						   	:asset,
							:category,
							:channel,
							:disposition,
							:initialResponseDueTime,
							:initialSolutionTime,
							:lastResponseTime,
							:mailbox,
							:mailing,
							:organization,
							:product,
							:referenceNumber,
							:resolutionInterval,
							:responseEmailAddressType,
							:responseInterval,
							:severity,
							:source

    remote_attr_reader  :id, 
                        :createdTime,
                        :updatedTime

    remote_post_accessor :assignedTo,
    					 :primaryContact

    rnow_object "incidents"

    def delete
      raise "Not supported"
    end

    def modify
      raise "Not supported"
    end
  end
end
