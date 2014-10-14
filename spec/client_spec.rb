require 'spec_helper'

describe 'Client' do
  let(:client){
    client = Xively::ApiClient.new
    allow(client).to receive(:json_parse).and_return []
    allow(client).to receive :post
    allow(client).to receive(:http_client).and_return http_client
    client
  }

  let(:http_client){
    double "http_client"
  }

  it 'uses environment variables' do
    ENV["XIVELY_PASS"] = 'pass'
    ENV["XIVELY_USER"] = 'user'
    ENV["XIVELY_INSTANCE"] = 'instance'
    ENV["XIVELY_DOMAIN"] = 'domain'
    expect(client.instance).to eq 'instance'
    expect(client.domain).to eq 'domain'
    expect(client.user).to eq 'user'
    expect(client.pass).to eq 'pass'
  end

  describe 'http verbs' do
  end

  describe 'creating a device' do
    after do
      expect(client).to have_received(:post).with(@expected_json)
    end

    it 'specifying serial id' do
      @expected_json = "{\"devices\":[{\"batch_id\":\"2ndnozefwvbsi\",\"queues\":[],\"serial\":\"id\"}]}"
      client.create_device 'id'
    end

    it 'specifying serial id and queues' do
      @expected_json = "{\"devices\":[{\"batch_id\":\"2ndnozefwvbsi\",\"queues\":[{\"name\":\"q1\",\"type\":\"message\"},{\"name\":\"q2\",\"type\":\"message\"}],\"serial\":\"id\"}]}"
      client.create_device 'id', queues: ['q1','q2']
    end

    it 'specifying batch id' do
      @expected_json = "{\"devices\":[{\"batch_id\":\"batch\",\"queues\":[],\"serial\":\"id\"}]}"
      client.create_device 'id', batch_id: 'batch' 
    end
  end

  it "deletes a device" do
  end
end
