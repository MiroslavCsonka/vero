# frozen_string_literal: true

require 'spec_helper'

describe Vero::Api::Workers::Users::UnsubscribeAPI do
  let(:payload) do
    {
      auth_token: 'abcd',
      email: 'test@test.com',
      changes: { email: 'test@test.com' }
    }
  end

  subject { Vero::Api::Workers::Users::UnsubscribeAPI.new('https://api.getvero.com', payload) }

  it_behaves_like 'a Vero wrapper' do
    let(:end_point) { '/api/v2/users/unsubscribe.json' }
  end

  describe :validate! do
    it 'should not raise an error when the keys are Strings' do
      options = { 'auth_token' => 'abcd', 'email' => 'test@test.com', 'changes' => { 'email' => 'test@test.com' } }
      subject.options = options
      expect { subject.send(:validate!) }.to_not raise_error
    end
  end

  describe :request do
    it 'should send a request to the Vero API' do
      expect(RestClient::Request).to(
        receive(:execute).with(
          method: :post,
          url: 'https://api.getvero.com/api/v2/users/unsubscribe.json',
          payload: { auth_token: 'abcd', email: 'test@test.com', changes: { email: 'test@test.com' } }.to_json,
          headers: { content_type: :json, accept: :json },
          timeout: 60
        )
      )
      allow(RestClient::Request).to receive(:execute).and_return(200)
      subject.send(:request)
    end
  end

  describe 'integration test' do
    it 'should not raise any errors' do
      allow(RestClient::Request).to receive(:execute).and_return(200)
      expect { subject.perform }.to_not raise_error
    end
  end
end
