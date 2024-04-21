class SessionsController < ApplicationController
    def google_login
        # Get access tokens from what google returned
        auth = request.env["omniauth.auth"]
        # Find user with auth info  
        user = User.from_omniauth(auth)
        log_in(user)
        # Find token
        token = user.tokens.find_or_initialize_by(provider: 'google')
        # Access_token is used to authenticate requests
        token.access_token = auth.credentials.token
        token.expires_at = auth.credentials.expires_at
        # Refresh_token to request new access_token
        # Note: Refresh_token is only sent once during the first request
        refresh_token = auth.credentials.refresh_token
        token.refresh_token = refresh_token if refresh_token.present?
        # save token
        token.save
        # back to root
        redirect_to root_path
    end

    def logout
        log_out
        # back to root
        redirect_to root_path
    end
end