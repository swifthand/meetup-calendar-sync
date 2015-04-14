# Load our patch to Google's OAuth2 Client until they accept
# this pull request:
#   https://github.com/google/signet/pull/54
# or otherwise correct the inability to override authorization_uri
require "signet/oauth_2/client"
load    "#{Rails.root}/lib/patches/signet/oauth_2/client.rb"

# Some tiny niceties on top of Ruby standard libs
require "#{Rails.root}/lib/patches/symbol"
require "#{Rails.root}/lib/patches/array"
require "#{Rails.root}/lib/patches/enumerable"
require "#{Rails.root}/lib/patches/enumerator"
