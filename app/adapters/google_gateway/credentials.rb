module GoogleGateway
  class Credentials

    attr_reader :store, :auth

    def initialize(auth: , redirect_uri: , from_hash: :not_provided, store: GoogleGateway.build_credentials_store)
      @store  = store
      refresh = determine_refresh(from_hash, store)
      @auth   = augment_auth(auth, redirect_uri, refresh)
    end


    def update_from_code(code)
      auth.code = code
      auth.fetch_access_token!
      persist_in_store
    end


    def authorization_uri
      auth.authorization_uri.to_s
    end


private ########################################################################

    def determine_refresh(from_hash, store)
      return from_hash unless from_hash.blank? or from_hash == :not_provided
      store.load_credentials
    end


    def augment_auth(auth, redirect_uri, refresh)
      auth.update!({
        approval_prompt: :force,
        access_type: :offline,
      })
      auth.redirect_uri = redirect_uri
      if refresh.present?
        auth.update_token!(refresh)
        if auth.expires_at.blank? or Time.now.to_i >= auth.expires_at
          auth.refresh!
        end
      end
      auth
    end


    def persist_in_store
      Google::APIClient::Storage.new(store).write_credentials(auth)
    end

  end
end
