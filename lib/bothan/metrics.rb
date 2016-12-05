module Bothan
  class Metrics
    include HTTParty
    headers 'Accept' => 'application/json'

    def initialize(username, password, endpoint)
      self.class.base_uri endpoint
      self.class.basic_auth username, password
    end

    def all
      (self.class.get('/metrics').parsed_response || {})['metrics']
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

    def create_single(name, value, time = DateTime.now)
      create_metric(name, value, time)
    end

    alias_method :create, :create_single

    def create_target(name, actual, annual_target, ytd_target = nil, time = DateTime.now)
      value = {
        actual: actual,
        annual_target: annual_target,
        ytd_target: ytd_target
      }.delete_if { |k, v| v.nil? }

      create_metric(name, value, time)
    end

    def create_multiple(name, values, time = DateTime.now)
      value = {
        total: values
      }

      create_metric(name, value, time)
    end

    def create_geo(name, features, time = DateTime.now)
      value = {
        type: "FeatureCollection",
        features: features
      }

      create_metric(name, value, time)
    end

    private

      def create_metric(name, value, time = DateTime.now)
        json = {
          time: time.to_s,
          value: value
        }.to_json
        self.class.post("/metrics/#{name}", body: json, headers: { 'Content-Type' => 'application/json' } )
      end

  end
end
