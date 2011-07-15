require 'fog/core/model'
require 'fog/dns/models/dynect/records'

module Fog
  module Dynect
    class DNS

      class Zone < Fog::Model

        identity  :id,            :aliases => 'serial'

        attribute :domain,        :aliases => 'zone'
        attribute :email,         :aliases => 'rname'
        attribute :serial_style
        attribute :ttl
        attribute :type,          :aliases => 'zone_type'

        def initialize(attributes={})
          self.ttl  ||= 3600
          super
        end

        def destroy
          requires :domain
          connection.delete_zone(domain)
          true
        end

        undef_method :domain=
        def domain=(new_domain)
          attributes[:domain] = new_domain.split('/').last
        end

        def records
          @records ||= Fog::Dynect::DNS::Records.new(:zone => self, :connection => connection)
        end

        def nameservers
          raise 'nameservers Not Implemented'
        end

        def save
          requires :domain, :email, :ttl
          data = connection.post_zone(email, ttl, domain).body['data']
          merge_attributes(data)
          true
        end

      end

    end
  end
end
