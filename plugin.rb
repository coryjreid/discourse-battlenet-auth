# name: discourse-battlenet-auth
# about: Discourse plugin to allow login via Battle.net
# version: 1.0.0
# authors: Cory J. Reid
# url: https://github.com/coryjreid/discourse-battlenet-auth

gem 'omniauth-bnet', '1.1.1'

class BattleNetAuthenticator < ::Auth::Authenticator

  def name
    'bnet'
  end

  def after_authenticate(auth_token)
    result = Auth::Result.new

    # grab the info we need from omni auth
    data = auth_token[:info]
    username = data.battletag
    bnet_uid = data.id

    # plugin specific data storage
    current_info = ::PluginStore.get("bnet", "bnet_uid_#{bnet_uid}")

    result.user =
      if current_info
        User.where(id: current_info[:user_id]).first
      end
    result.username = username
    result.extra_data = { bnet_uid: bnet_uid }

    result
  end

  def after_create_account(user, auth)
    data = auth[:extra_data]
    ::PluginStore.set("bnet", "bnet_uid_#{data[:bnet_uid]}", {user_id: user.id })
  end

  def register_middleware(omniauth)
    omniauth.provider :bnet,
     SiteSetting.battlenet_client_id,
     SiteSetting.battlenet_client_secret
    
    # correct the host in development, leave commented in production! 
    # OmniAuth.config.full_host = "https://disctest"
  end
end

auth_provider title_setting: "battlenet_button_title",
              enabled_setting: "battlenet_enabled",
              message: "Log in via Battle.net (Make sure pop up blockers are not enabled).",
              frame_width: 920,
              frame_height: 800,
              authenticator: BattleNetAuthenticator.new


# Using Socicon to get Battle.net icon, see: http://www.socicon.com/
register_css <<CSS

@font-face {
  font-family: 'Socicon';
  src: url('/plugins/discourse-battlenet-auth/fonts/Socicon.eot');
  src: url('/plugins/discourse-battlenet-auth/fonts/Socicon.eot#iefix') format('embedded-opentype'), 
    url('/plugins/discourse-battlenet-auth/fonts/Socicon.woff2') format('woff2'), 
    url('/plugins/discourse-battlenet-auth/fonts/Socicon.ttf') format('truetype'), 
    url('/plugins/discourse-battlenet-auth/fonts/Socicon.woff') format('woff'), 
    url('/plugins/discourse-battlenet-auth/fonts/Socicon.svg#Socicon') format('svg');
  font-weight: normal;
  font-style: normal;
}

.btn-social.bnet {
  background: #000000;
  speak: none;
  /* Better Font Rendering =========== */
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.btn-social.bnet:before {
  /* use !important to prevent issues with browser extensions that change fonts */
  font-family: 'Socicon' !important;
  font-style: normal;
  font-weight: normal;
  font-variant: normal;
  text-transform: none;
  position: relative;
  top: 2px;
  line-height: 16px;
  content: "";
}

CSS
