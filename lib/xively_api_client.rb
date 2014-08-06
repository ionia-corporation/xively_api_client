require "xively_api_client/version.rb"

module XivelyApiClient
  class Client
    attr_accessor :domain, :instance, :user, :pass

    def initialize args = {}
      @instance = args[:instance] || ENV['XIVELY_INSTANCE']
      @domain = args[:domain] || ENV['XIVELY_DOMAIN']
      @user = args[:user] || ENV['XIVELY_USER']
      @pass = args[:pass] || ENV['XIVELY_PASS']
    end

    def create_device serial_id, options = {}
      if serial_id
        response = post(create_device_json serial_id, options)
        JSON.parse(response.body)["devices"].first
      end
    end

    def devices
      begin
        response = HTTParty.get device_url, basic_auth: credentials
        JSON.parse(response.body)["devices"]
      rescue
        nil
      end
    end

    def delete serial
      HTTParty.delete device_url(serial),
                      :basic_auth => credentials
    end

    private

    def post body
      HTTParty.post device_url,
                    :body => body,
                    :basic_auth => credentials,
                    :headers => {'Content-Type' => 'application/json'}
    end

    def device_url serial = nil
      url = "https://v3api.xively.com/v3/service_instances/#{ instance }/domains/#{ domain }/devices"
      url += "/#{ serial }" if serial
      url
    end

    def credentials
      { username: @user, password: @pass }
    end

    def create_device_json serial_id, options = {}
      queues = options[:queues] || []
      batch_id = options[:batch_id] || "2ndnozefwvbsi"
      { devices:
        [{ batch_id: batch_id,
          queues: queues.map { |q| { name: q, type: "message" } },
          serial: serial_id
        }]
      }.to_json
    end

  end
end
