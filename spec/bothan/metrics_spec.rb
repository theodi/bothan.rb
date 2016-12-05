require 'spec_helper'

module Bothan
  describe Metrics, :vcr do

    before(:each) do
      @metrics = described_class.new('username', 'password', 'https://demo.bothan.io')
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

    it 'gets metrics for a range' do
      expect(@metrics.find('simple-metric', '2016-11-02T14:55:07+00:00','2016-12-02T14:55:07+00:00')).to eq({
        "count" => 5,
        "values" => [
          {"time"=>"2016-11-28T07:00:16.534+00:00", "value"=>16},
          {"time"=>"2016-11-29T07:00:16.516+00:00", "value"=>8},
          {"time"=>"2016-11-30T07:00:16.497+00:00", "value"=>86},
          {"time"=>"2016-12-01T07:00:16.475+00:00", "value"=>32},
          {"time"=>"2016-12-02T07:00:16.450+00:00", "value"=>22}
        ]
      })
    end

    it 'creates a simple metric' do
      @metrics.create('my-new-metric', 12, "2016-11-28T09:00:00")
      expect(@metrics.find('my-new-metric')).to eq({
        "_id" => {"$oid"=>"5841e4386fa6570004f8d016"},
        "name"=>"my-new-metric",
        "time"=>"2016-11-28T09:00:00.000+00:00",
        "value"=>12
      })
    end

    it 'creates a value with a target' do
      @metrics.create_target('my-new-target-metric', 1091000, 2862000, 1368000, "2016-11-28T09:00:00")
      expect(@metrics.find('my-new-target-metric')).to eq({
        "_id" => {"$oid"=>"5841e5186fa6570004f8d018"},
        "name"=>"my-new-target-metric",
        "time"=>"2016-11-28T09:00:00.000+00:00",
        "value"=>{
          "actual" => 1091000,
          "annual_target" => 2862000,
          "ytd_target" => 1368000
        }
      })
    end

    it 'creates a metric without a ytd target' do
      @metrics.create_target('my-awesome-new-target-metric', 1091000, 2862000, nil, "2016-11-28T09:00:00")
      expect(@metrics.find('my-awesome-new-target-metric')).to eq({
        "_id" => {"$oid"=>"58452fa8c5661700040e61dc"},
        "name"=>"my-awesome-new-target-metric",
        "time"=>"2016-11-28T09:00:00.000+00:00",
        "value"=>{
          "actual" => 1091000,
          "annual_target" => 2862000,
        }
      })
    end

    it 'creates a metric with multiple values' do
      values = {
        "value1" => 123,
        "value2" => 23213,
        "value4" => 1235
      }
      @metrics.create_multiple('my-awesome-mulitple-metric', values, "2016-11-28T09:00:00")
      expect(@metrics.find('my-awesome-mulitple-metric')).to eq({
        "_id" => {"$oid"=>"5845335cc5661700040e61de"},
        "name"=>"my-awesome-mulitple-metric",
        "time"=>"2016-11-28T09:00:00.000+00:00",
        "value"=>{
          "total" => values
        }
      })
    end

    it 'creates a geo metric' do
      values = [
        {
          "type" => "Feature",
          "geometry" => {
            "type" => "Point",
            "coordinates" => [-2.6156582783015017, 54.3497405310758]
          }
        },
        {
          "type" => "Feature",
          "geometry" => {
            "type" => "Point",
             "coordinates" => [-6.731370299641439, 55.856756177781186]
          }
        }
      ]

      @metrics.create_geo('my-awesome-geo-metric', values, "2016-11-28T09:00:00")
      expect(@metrics.find('my-awesome-geo-metric')).to eq({
        "_id" => {"$oid"=>"584535a6c5661700040e61e0"},
        "name"=>"my-awesome-geo-metric",
        "time"=>"2016-11-28T09:00:00.000+00:00",
        "value"=>{
          "type" => "FeatureCollection",
          "features" => values
        }
      })
    end

  end
end
