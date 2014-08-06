require "xively_api_client/version.rb"
require 'httparty'
require 'json'

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
      json_parse(post(create_device_json serial_id, options)).first
    end

    def find_by serial_id
      json_parse( get device_url serial_id ).first
    end

    def devices
      json_parse(get device_url)
    end

    def destroy_device serial
      delete device_url(serial)
    end

    private

    def json_parse response
      JSON.parse(response.body)["devices"]
    end

    def get url
      HTTParty.get url, basic_auth: credentials
    end

    def post body
      HTTParty.post device_url,
                    :body => body,
                    :basic_auth => credentials,
                    :headers => {'Content-Type' => 'application/json'}
    end

    def delete url
      HTTParty.delete url,
                      :basic_auth => credentials
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
