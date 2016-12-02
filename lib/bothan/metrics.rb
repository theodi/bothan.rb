module Bothan
  class Metrics
    include HTTParty
    headers 'Accept' => 'application/json'

    def initialize(endpoint, username, password)
      self.class.base_uri endpoint
      self.class.basic_auth username, password
    end

    def all
      self.class.get('/metrics').parsed_response
    end

    def find(metric, from = nil, to = nil)
      if from.nil? && to.nil?
        metric = self.class.get("/metrics/#{metric}").parsed_response
      elsif !from.nil? && to.nil?
        metric = self.class.get("/metrics/#{metric}/#{from}").parsed_response
      elsif !from.nil? && !to.nil?
        metric = self.class.get("/metrics/#{metric}/#{from}/#{to}").parsed_response
      end
      raise MetricNotFound if metric.nil?
      metric
    end

  end
end
