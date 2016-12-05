require 'spec_helper'

module Bothan
  describe Connection do

    it 'sets username, password and endpoint' do
      bothan = Bothan::Connection.new('username', 'password', 'http://bothan.example.org')

      expect(bothan.instance_variable_get('@username')).to eq('username')
      expect(bothan.instance_variable_get('@password')).to eq('password')
      expect(bothan.instance_variable_get('@endpoint')).to eq('http://bothan.example.org')
    end

  end
end
