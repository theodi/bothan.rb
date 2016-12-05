require 'spec_helper'

module Bothan
  describe Connection do

    before(:each) do
      @bothan = Bothan::Connection.new('username', 'password', 'http://bothan.example.org')
    end

    it 'sets username, password and endpoint' do
      expect(@bothan.instance_variable_get('@username')).to eq('username')
      expect(@bothan.instance_variable_get('@password')).to eq('password')
      expect(@bothan.instance_variable_get('@endpoint')).to eq('http://bothan.example.org')
    end

    it 'returns a metrics instance' do
      expect(@bothan.metrics).to be_an_instance_of(Bothan::Metrics)
    end

    it 'sets the right credentials' do
      expect(Bothan::Metrics).to receive(:new).with('username', 'password', 'http://bothan.example.org')
      @bothan.metrics
    end

  end
end
