module Bothan
  class Metrics
    include HTTParty
    headers 'Accept' => 'application/json'

    def initialize(endpoint)
      self.class.base_uri endpoint
    end

    def list
      self.class.get('/metrics').parsed_response
    end

  end
end
