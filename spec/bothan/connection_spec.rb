require 'spec_helper'

module Bothan
  describe Connection do

    it 'creates an endpoint with username and password' do
      bothan = Bothan::Connection.new('username', 'password', 'http://bothan.example.org')
      endpoint = bothan.instance_variable_get('@endpoint')
      expect(endpoint.to_s).to eq('http://username:password@bothan.example.org')
    end

  end
end
