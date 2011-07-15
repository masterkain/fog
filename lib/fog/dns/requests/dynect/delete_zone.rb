module Fog
  module Dynect
    class DNS
      class Real

        # Delete a zone
        #
        # ==== Parameters
        # * zone<~String> - zone to host

        def delete_zone(zone)
          request(
            :expects  => 200,
            :method   => :delete,
            :path     => "Zone/#{zone}"
          )
        end
      end
    end
  end
end
