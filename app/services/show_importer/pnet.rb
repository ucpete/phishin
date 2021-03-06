# frozen_string_literal: true
class ShowImporter::PNet
  BASE_URL = 'https://api.phish.net/endpoint.php'

  def initialize(api_key)
    @options = {
      'api' => '2.0',
      'apikey' => api_key,
      'format' => 'json'
    }
    @url = URI.parse(BASE_URL)
  end

  def perform_action(opts)
    url = URI.parse(BASE_URL)
    request = Net::HTTP::Post.new(url.path)
    request.set_form_data(@options.merge(opts))
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    res = http.start { |ht| ht.request(request) }
    case res
    when Net::HTTPSuccess
      begin
        return JSON::Parser.new(res.body).parse
      rescue StandardError
        raise 'Server or Parse Error'
      end
    else
      raise 'Server Error'
    end
  end

  # Will cause the Authkey to be used from this point forward.
  def api_authorize(opts = {})
    opts['method'] = 'pnet.api.authorize'
    auth = perform_action(opts)
    raise 'Authentication Failure' unless auth['success'] == 1

    @options['authkey'] = auth['authkey']
    true
  end

  # Forget the auth key.
  def deauthorize
    @options.delete('authkey')
  end

  def method_missing(method, *args, &_block)
    action = "pnet_#{method}".tr('_', '.')
    opts = args.first || {}
    opts['method'] = action
    perform_action(opts)
  end
end
