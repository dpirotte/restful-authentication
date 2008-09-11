require 'ldap'

module Authentication
  module ByActiveDirectory
    # Stuff directives into including module 
    def self.included(recipient)
      recipient.extend(ModelClassMethods)
      recipient.class_eval do
        include ModelInstanceMethods
      end
    end

    #
    # Class Methods
    #
    module ModelClassMethods
    end # class methods

    #
    # Instance Methods
    #
    module ModelInstanceMethods
      def ad_authenticated?(password)
        config = YAML::load(File.open("#{RAILS_ROOT}/config/restful_authentication.yml"))
      	conn = LDAP::Conn.new(config['active_directory']['host'], config['active_directory']['port'])
  			conn.set_option(LDAP::LDAP_OPT_PROTOCOL_VERSION, 3)
  			conn.bind("#{login}@#{config['active_directory']['domain']}", password)
  			!conn.search2(config['active_directory']['dn'], LDAP::LDAP_SCOPE_SUBTREE, "sAMAccountName=#{login}").empty?
      ensure
        conn.unbind
      end
    end
    
  end
end