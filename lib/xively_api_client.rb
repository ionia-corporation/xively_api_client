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

    def index_devices
      json_parse(get device_url)
    end

    def show_device serial_id
      response = get device_url serial_id
      json_parse(response).first
    end

    def create_device serial_id, options = {}
      json_parse(post(build_json serial_id, options)).first
    end

    # Not implemented in API? Or only can change "batch_id": and "device_secret":

    # def update_device serial_id, options = {}
    #   device = show_device serial_id
    #   unless (device)
    #     json_parse put(device.to_json).first
    #   end
    # end

    # def put body
    #   HTTParty.put device_url,
    #                 :body => body,
    #                 :basic_auth => credentials,
    #                 :headers => {'Content-Type' => 'application/json'}
    # end

    def destroy_device serial
      delete device_url(serial)
    end

    private

    def json_parse response
      JSON.parse(response.body)["devices"] || []
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
      HTTParty.delete url, :basic_auth => credentials
    end

    def device_url serial = nil
      url = "https://v3api.xively.com/v3/service_instances/#{ instance }/domains/#{ domain }/devices"
      url += "/#{ serial }" if serial
      url
    end

    def credentials
      { username: @user, password: @pass }
    end

    def build_json serial_id, options = {}
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
