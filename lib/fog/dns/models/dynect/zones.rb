require 'fog/core/collection'
require 'fog/dns/models/dynect/zone'

module Fog
  module Dynect
    class DNS

      class Zones < Fog::Collection

        model Fog::Dynect::DNS::Zone

        def all
          data = connection.get_zone.body['data'].map do |zone|
            { :domain => zone }
          end
          load(data)
        end

        def get(zone_id)
          new(connection.get_zone('zone' => zone_id).body['data'])
        end

      end

    end
  end
end
