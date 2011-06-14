require 'uri'
require 'faraday'

module Protolink
  class Connection

    attr_reader :domain, :username, :password, :uri, :options

    def self.connection
      @connection ||= Faraday::Connection.new do |conn|
        conn.use      Faraday::Request::ActiveSupportJson
        conn.adapter  :net_http
        conn.use      Protolink::FaradayResponse::RaiseOnAuthenticationFailure
        conn.use      Faraday::Response::ActiveSupportJson
        conn.use      Protolink::FaradayResponse::WithIndifferentAccess

        conn.headers['Content-Type'] = 'application/json'
      end
    end

    def self.raw_connection
      @raw_connection ||= Faraday::Connection.new do |conn|
        conn.adapter  Faraday.default_adapter
        conn.use      Protolink::FaradayResponse::RaiseOnAuthenticationFailure
        conn.use      Faraday::Response::ActiveSupportJson
        conn.use      Protolink::FaradayResponse::WithIndifferentAccess
      end
    end

    def initialize(domainname, username, password, options = {})
      @domainname   = domainname
      @username = username
      @password = password
      @options  = { :ssl => false, :proxy => ENV['HTTP_PROXY'] }.merge(options)
      @uri = URI.parse("#{@options[:ssl] ? 'https' : 'http' }://#{domainname}")

      connection.basic_auth username, password
      raw_connection.basic_auth username, password
    end

    def connection
      @connection ||= begin
        conn = self.class.connection.dup
        conn.url_prefix = @uri.to_s
        conn.proxy options[:proxy]
        conn
      end
    end

    def raw_connection
      @raw_connection ||= begin
        conn = self.class.raw_connection.dup
        conn.url_prefix = @uri.to_s
        conn.proxy options[:proxy]
        conn
      end
    end

    def get(url, *args)
      response = connection.get(url, *args)
      response.body
    end

    def post(url, body = nil, *args)
      response = connection.post(url, body, *args)
      response.body
    end

    def raw_post(url, body = nil, *args)
      response = raw_connection.post(url, body, *args)
    end

    def put(url, body = nil, *args)
      response = connection.put(url, body, *args)
      response.body
    end

    # Is the connection using ssl?
    def ssl?
      uri.scheme == 'https'
    end
  end
end
