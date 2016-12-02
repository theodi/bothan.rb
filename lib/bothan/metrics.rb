module Bothan
  class Metrics
    include HTTParty
    headers 'Accept' => 'application/json'

    def initialize(endpoint)
      self.class.base_uri endpoint
    end

    def all
      self.class.get('/metrics').parsed_response
    end

    def find(metric)
      metric = self.class.get("/metrics/#{metric}").parsed_response
      raise MetricNotFound if metric.nil?
      metric
    end

  end
end
