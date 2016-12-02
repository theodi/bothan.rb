require 'spec_helper'

module Bothan
  describe Metrics, :vcr do

    before(:each) do
      @metrics = described_class.new('https://username:password@demo.bothan.io')
    end

    it 'lists metrics', :vcr do
      expect(@metrics.list).to eq({
        "metrics" => [
          {
            "name"=>"metric-with-geodata",
            "url"=>"https://demo.bothan.io/metrics/metric-with-geodata.json"
          },
          {
            "name"=>"metric-with-multiple-values",
            "url"=>"https://demo.bothan.io/metrics/metric-with-multiple-values.json"
          },
          {
            "name"=>"metric-with-target",
            "url"=>"https://demo.bothan.io/metrics/metric-with-target.json"
          },
          {
            "name"=>"metric-with-ytd-target",
            "url"=>"https://demo.bothan.io/metrics/metric-with-ytd-target.json"
          },
          {
            "name"=>"simple-metric",
            "url"=>"https://demo.bothan.io/metrics/simple-metric.json"
          }
        ]
      })
    end

  end
end
