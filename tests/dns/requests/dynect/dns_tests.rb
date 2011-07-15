Shindo.tests('Dynect::dns | DNS requests', ['dynect', 'dns']) do

  shared_format = {
    'job_id' => Integer,
    'msgs' => [{
      'ERR_CD'  => Fog::Nullable::String,
      'INFO'    => String,
      'LVL'     => String,
      'SOURCE'  => String
    }],
    'status' => String
  }

  tests "success" do

    post_session_format = shared_format.merge({
      'data' => {
        'token'   => String,
        'version' => String
      }
    })

    tests("post_session").formats(post_session_format) do
      Dynect[:dns].post_session.body
    end

    post_zone_format = shared_format.merge({
      'data' => {
        'serial'        => Integer,
        'zone'          => String,
        'zone_type'     => String,
        'serial_style'  => String
      }
    })

    tests("post_zone('netops@#{@domain}', 3600, '#{@domain}')").formats(post_zone_format) do
      @domain = generate_unique_domain
      Dynect[:dns].post_zone("netops@#{@domain}", 3600, @domain).body
    end

    get_zones_format = shared_format.merge({
      'data' => [String]
    })

    tests("get_zone").formats(get_zones_format) do
      Dynect[:dns].get_zone.body
    end

    get_zone_format = shared_format.merge({
      'data' => {
        "serial"        => Integer,
        "serial_style"  => String,
        "zone"          => String,
        "zone_type"     => String
      }
    })

    tests("get_zone('zone' => '#{@domain}')").formats(get_zone_format) do
      Dynect[:dns].get_zone('zone' => @domain).body
    end

    get_node_list_format = shared_format.merge({
      'data' => [String]
    })

    tests("get_node_list('#{@domain}')").formats(get_node_list_format) do
      body = Dynect[:dns].get_node_list(@domain).body
      @fqdn = body['data'].first
      body
    end

    get_records_format = shared_format.merge({
      'data' => [String]
    })

    tests("get_record('ANY', '#{@domain}', '#{@fqdn}')").formats(get_records_format) do
      Dynect[:dns].get_record('ANY', @domain, @fqdn).body
    end

    post_record_format = shared_format.merge({
      'data' => {
        'fqdn'        => String,
        'rdata'       => {
          'address' => String
        },
        'record_id'   => Integer,
        'record_type' => String,
        'ttl'         => Integer,
        'zone'        => String
      }
    })

    tests("post_record('A', '#{@domain}', 'www.#{@domain}', 'address' => '1.2.3.4')").formats(post_record_format) do
      body = Dynect[:dns].post_record('A', @domain, "www.#{@domain}", 'address' => '1.2.3.4').body
      @record_id = body['data']['record_id']
      body
    end

    delete_record_format = shared_format.merge({

    })

    tests("delete_record('A', '#{@domain}', 'www.#{@domain}', '#{@record_id}')").formats(delete_record_format) do
      Dynect[:dns].delete_record('A', @domain, "www.#{@domain}", @record_id).body
    end

    # tests "update record"
    # tests "publish changes"

    delete_zone_format = shared_format.merge({
      'data' => {}
    })

    tests("delete_zone('#{@domain}')").formats(delete_zone_format) do
      Dynect[:dns].delete_zone(@domain).body
    end

    tests "list jobs"
  end
end
