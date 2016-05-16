require "httparty"
require "tempfile"

class SauceLog
  include HTTParty

  # Parse the response body however you like
  class Parser::Simple < HTTParty::Parser
    def parse
      body
    end
  end

  parser Parser::Simple
  base_uri "https://saucelabs.com/rest/v1/dylanatsauce/jobs"

  def initialize
    @auth = {username: ENV["SAUCE_USERNAME"], password: ENV["SAUCE_ACCESS_KEY"]}
  end

  def sauce_log(options = {})
    id = options.delete :id
    options.merge!({basic_auth: @auth})
    content = self.class.get("/#{id}/assets/log.json", options)
    # file = Tempfile.new(id)
    # file.write content
    # file.close
    return content
  end
end