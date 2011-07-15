module Fog
  module Dynect
    class DNS
      class Real

        def post_session
          request(
            :expects  => 200,
            :method   => :post,
            :path     => "Session",
            :body     => {
              :customer_name  => @dynect_customer,
              :user_name      => @dynect_username,
              :password       => @dynect_password
              }.to_json
          )
        end
      end

      class Mock

        def post_session
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'API-Version' => '2.3.1',
            'Auth-Token' => 'thetoken=='
          }
          response
        end

      end

    end
  end
end
