##
# WARNING:  THIS IS A TEMPORARY WORKAROUND. IF YOU ARRIVE HERE
#           BECAUSE OF AN ERROR, DELETE THIS FILE AND LOOK FOR
#           A NEW SOLUTION. DO NOT ATTEMPT TO MODIFY THIS FILE.
#
# If you have newly installed, or have upgraded to a version of
# the signet gem beyond 0.6.0, there is a chance that Google has
# fixed the error that necessitated this patch.
#
# I repeat, DO NOT attempt to modify this file. In fact, deleting
# this file might actually cause things to function properly!
#
# Relevant Gist:
#   https://gist.github.com/swifthand/7c35c2c56619db5abbfd
# Relevant Fix & Pull Request:
#   https://github.com/swifthand/signet/commit/7352ba230bc8014f147ae344a9a84eb0552e67e8
#   https://github.com/google/signet/pull/54
module Signet
  module OAuth2
    class Client
      def authorization_uri(options={})
        # Normalize external input
        options = deep_hash_normalize(options)

        return nil if @authorization_uri == nil
        unless options[:response_type]
          options[:response_type] = :code
        end
        unless options[:access_type]
          options[:access_type] = :offline
        end
        options[:client_id] ||= self.client_id
        options[:redirect_uri] ||= self.redirect_uri
        if options[:prompt] && options[:approval_prompt]
          raise ArgumentError, "prompt and approval_prompt are mutually exclusive parameters"
        end
        if !options[:client_id]
          raise ArgumentError, "Missing required client identifier."
        end
        unless options[:redirect_uri]
          raise ArgumentError, "Missing required redirect URI."
        end
        if !options[:scope] && self.scope
          options[:scope] = self.scope.join(' ')
        end
        options[:state] = self.state unless options[:state]
        options.merge!(self.additional_parameters.merge(options[:additional_parameters] || {}))
        options.delete(:additional_parameters)
        options = Hash[options.map do |key, option|
          [key.to_s, option]
        end]
        uri = Addressable::URI.parse(
          ::Signet::OAuth2.generate_authorization_uri(
            @authorization_uri, options
          )
        )
        if uri.normalized_scheme != 'https'
          raise Signet::UnsafeOperationError,
            'Authorization endpoint must be protected by TLS.'
        end
        return uri
      end
    end
  end
end
