require 'fog/core/collection'
require 'fog/dns/models/dynect/record'

module Fog
  module Dynect
    class DNS

      class Records < Fog::Collection

        attribute :zone

        model Fog::Dynect::DNS::Record

        def all
          requires :zone
          data = []
          connection.get_node_list(zone.domain).body['data'].each do |fqdn|
            records = connection.get_record('ANY', zone.domain, fqdn).body['data']

            # data in format ['/REST/xRecord/domain/fqdn/identity]
            records.map! do |record|
              tokens = record.split('/')
              {
                :identity => tokens.last,
                :fqdn     => fqdn,
                :type     => tokens[2][0...-6] # everything before 'Record'
              }
            end

            data.concat(records)
          end

          load(data)
        end

        def get(record_id)
          raise 'get is not implemented yet'
        end

        def new(attributes = {})
          requires :zone
          super({ :zone => zone }.merge!(attributes))
        end

      end

    end
  end
end
