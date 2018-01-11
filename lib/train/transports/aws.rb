require 'train/plugins'
require 'aws-sdk'

module Train::Transports
  class Aws < Train.plugin(1)
    name 'aws'
    option :region, required: true, default: ENV['AWS_REGION']
    option :access_key_id, default: ENV['AWS_ACCESS_KEY_ID']
    option :secret_access_key, default: ENV['AWS_SECRET_ACCESS_KEY']
    option :session_token, default: ENV['AWS_SESSION_TOKEN']

    # This can provide the access key id and secret access key
    option :profile, default: ENV['AWS_PROFILE']

    def connection(_ = nil)
      @connection ||= Connection.new(@options)
    end

    class Connection < BaseConnection
      def initialize(options)
        super(options)
        # login_command
      end

      def platform
        direct_platform('aws')
      end

      def local?
        true
      end

      def aws_client(klass)
        @cache[klass.to_sym] ||= klass.new
      end

      def connect
        creds = Aws::Credentials.new(
          @options[:aws_access_key_id],
          @options[:aws_secret_access_key],
          @options[:aws_session_token],
        )
        opts = {
          region: @options[:region],
          credentials: creds,
        }
        Aws.config.update(opts)
      end

      def uri
        'local://'
      end
    end
  end
end
