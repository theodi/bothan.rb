module Bothan
  class Connection

    def initialize(username, password, endpoint)
      @endpoint = URI(endpoint)
      @endpoint.userinfo = "#{username}:#{password}"
    end

  end
end
