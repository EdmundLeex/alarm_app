class FacebookOauth
  GRAPH_API_URI = "https://graph.facebook.com".freeze

  def self.valid_identity?(oauth_identity)
    uri = URI("#{GRAPH_API_URI}/debug_token?")
    params = { input_token: oauth_identity.access_token, access_token: ENV['FACEBOOK_ACCESS_TOKEN'] }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)

    app_id = JSON.parse(res.body)['data']['app_id'] 
    app_id == ENV['FACEBOOK_APP_ID']
  end
end