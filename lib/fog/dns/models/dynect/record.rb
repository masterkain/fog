require 'fog/core/model'

module Fog
  module Dynect
    class DNS

      class Record < Fog::Model
        extend Fog::Deprecation

        identity  :id,          :aliases => 'record_id'
        attribute :fqdn
        attribute :name,        :aliases => 'fqdn'
        attribute :rdata
        attribute :serial_style
        attribute :ttl
        attribute :type,        :aliases => 'record_type'
        attribute :value
        attribute :zone_id,     :aliases => 'zone'

        def destroy
          requires :fqdn, :identity, :zone_id
          connection.delete_record(zone_id, fqdn, identity)
          true
        end

        def save
          raise 'save not implemented'
        end

      end

    end
  end
end
