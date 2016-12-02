require 'spec_helper'

module Bothan
  describe Metrics, :vcr do

    before(:each) do
      @metrics = described_class.new('https://username:password@demo.bothan.io')
    end

    it 'lists metrics' do
      expect(@metrics.all).to eq({
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

    it 'gets a metric' do
      expect(@metrics.find('simple-metric')).to eq({
        "_id" => {"$oid"=>"58411c0044f5440004aaad03"},
        "name"=>"simple-metric",
        "time"=>"2016-12-02T07:00:16.450+00:00",
        "value"=>22
      })
    end

    it 'returns an error for a non-existent metric' do
      expect { @metrics.find('not-a-metric') }.to raise_error(Bothan::MetricNotFound)
    end

    it 'gets a metric for a datetime' do
      expect(@metrics.find('simple-metric', '2016-11-28T07:00:16.534+00:00')).to eq({
        "_id" => {"$oid"=>"58411c0044f5440004aaad23"},
        "name"=>"simple-metric",
        "time"=>"2016-11-28T07:00:16.534+00:00",
        "value"=>16
      })
    end

  end
end
