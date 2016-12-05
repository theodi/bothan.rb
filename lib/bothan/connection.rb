module Bothan
  class Connection

    def initialize(username, password, endpoint)
      @username, @password, @endpoint = username, password, endpoint
    end

    def metrics
      @metrics ||= Metrics.new(@username, @password, @endpoint)
    end

  end
end
