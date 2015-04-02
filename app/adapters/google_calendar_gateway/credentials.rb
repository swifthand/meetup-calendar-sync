module GoogleCalendarGateway
  class Credentials

    delegate  :authorization_uri,
              :to => :@auth

    attr_reader :store

    def initialize(redirect_uri, session, store: GoogleCalendarGateway.build_credentials_store)
      @store  = store
      @auth   = build_auth(redirect_uri, session_as_hash(session))
    end


    def update(code, session)
      auth.code = code
      auth.fetch_access_token!
      persist_in_session(session)
      persist_in_store
    end


private ########################################################################

    attr_reader :auth

    def session_as_hash(session)
      session['lazy_punks'] # Force loading of session if it has not yet been.
      session_hash =
        if !(Hash === session) and session.respond_to?(:to_hash)
          session.to_hash.symbolize_keys
        elsif !(Hash === session) and session.respond_to?(:to_h)
          session.to_h.symbolize_keys
        else
          session
        end
    end


    def build_auth(redirect_uri, session_hash)
      auth = GoogleCalendarGateway.api_client.authorization.dup
      auth.update!({
        approval_prompt: :force,
        access_type: :offline,
      })
      auth.redirect_uri = redirect_uri
      auth.update_token!(session_hash)
      auth
    end


    def persist_in_session(session)
      session.merge!({
        "access_token"  => auth.access_token,
        "refresh_token" => auth.refresh_token,
        "expires_in"    => auth.expires_in,
        "issued_at"     => auth.issued_at,
      })
    end


    def persist_in_store
      Google::APIClient::Storage.new(self.store).write_credentials(auth)
    end

  end
end
