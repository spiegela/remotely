require "forwardable"
require "faraday"
require "active_support/inflector"
require "active_support/concern"
require "active_support/core_ext/hash"
require "active_model"
require "remotely/ext/url"

module Remotely
  autoload :Collection,   "remotely/collection"
  autoload :Associations, "remotely/associations"
  autoload :Model,        "remotely/model"
  autoload :HTTPMethods,  "remotely/http_methods"

  class RemotelyError < StandardError
    def message; self.class::MESSAGE; end
  end

  class URLHostError < RemotelyError
    MESSAGE = "URL object missing host"
  end

  class RemoteAppError < RemotelyError
    MESSAGE = "No app specified for association with more than one app registered."
  end

  class HasManyForeignKeyError < RemotelyError
    MESSAGE = "has_many associations can use the :foreign_key option."
  end

  class NonJsonResponseError < RemotelyError
    MESSAGE = "Received an HTML response. Expected JSON."
    attr_reader :body

    def initialize(body)
      @body = body
    end
  end

  class << self
    # @return [Hash] Hash of registered apps (key: name, value: URL)
    def apps
      @apps ||= {}
    end

    # Configure applications to be used by models. Accepts a block
    # which specifies multiple apps via the `app` method.
    #
    # @param [Proc] block Configuration block.
    #
    # @example Registers an app named :fun with a URL of "http://fun.com/api/"
    #   Remotely.configure do
    #     app :fun, "http://fun.com/api/"
    #   end
    #
    def configure(&block)
      instance_eval(&block)
    end

    # Register an application with Remotely.
    #
    # @param [Symbol] name Placeholder name for the application.
    # @param [String] url URL to the application's API.
    #
    def app(name, url)
      url  = URI.parse(url)
      apps[name] = { base: "#{url.scheme || "http"}://#{url.host}:#{url.port}", uri: url.path }
    end

    # Set the Basic Auth user and password to use when making
    # requests.
    #
    # @param [String] user BasicAuth user
    # @param [String] password BasicAuth password
    #
    def basic_auth(user=nil, password=nil)
      user and password and @basic_auth = [user, password] or @basic_auth
    end
    
    # Set the default parameters to use when making
    # requests.
    #
    # @param [Hash] params Parameter Hash
    #
    def default_params(default_params=nil)
      default_params and @default_params = default_params or @default_params or {}
    end

    # Clear all registered apps
    #
    def reset!
      @apps = {}
      @default_params = {}
      @basic_auth = nil
    end
  end
end

module ActiveRecord
  class Base; include Remotely::Associations end
end
