require 'omniauth/strategies/oauth2'
# require 'omniauth-oauth'
require 'multi_json'

module OmniAuth
  module Strategies

    class Myapp < OmniAuth::Strategies::OAuth2
      
      # option :name, 'mysite'
      
      option :client_options, {
        :site => 'https://api.myapp.dev',
        :authorize_url => "https://api.myapp.dev/oauth/authorize",
        :token_url => 'oauth/token'
      }
      
      uid { 
        user_info['id']
      }
      
      info do 
        {
          #:nickname => user_info['username'],
          :email => user_info['email'],
          #:name => user_info['fullname'],
          #:first_name => user_info['firstname'],
          #:last_name => user_info['lastname'],
          #:description => user_info['about'],
          #:image => user_info['userpic_url'],
          #:urls => {
          #  '500px' => user_info['domain'],
          #  'Website' => user_info['contacts']['website']
          #}
        }
      end
      
      extra do
        {
          :raw_info => raw_info
        }
      end

      # Return info gathered from the flickr.people.getInfo API call 
     
      def raw_info
        @raw_info ||= JSON.parse(access_token.get('api/me').body)        
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end

      # Provide the "Person" portion of the raw_info
      
      def user_info        
        @user_info ||= raw_info.nil? ? {} : raw_info["user"]
      end
      
      def request_phase
        options[:authorize_params] = {:perms => options[:scope]} if options[:scope]
        super
      end
    end
  end
end
