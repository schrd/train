# encoding: utf-8

require 'helper'
require 'train/transports/aws'

describe 'aws transport' do
  let(:klass) do
    plat = Train::Platforms.name('aws').in_family('cloud')
    plat.add_platform_methods
    Train::Platforms::Detect.stubs(:scan).returns(plat)
    ENV['AWS_ACCESS_KEY_ID'] = 'AKIA'
    ENV['AWS_SECRET_ACCESS_KEY'] = ''
    Train::Transports::Aws
  end

  let(:aws) { klass.new({ region: 'us-east-1'}) }

  describe 'options' do
    it 'can be instantiated (with valid config)' do
      aws.wont_be_nil
    end
  
    it 'configures the provided region' do
      aws.options[:region].must_equal 'us-east-1'
    end
  end

  # I want to:
  #   AWS SDK deps OK
  #   Try to use train caching to handle caching Client objects (see base_connection)
  #   Try to have generic / metaprogramming approach to getting new Clients
  #   Verify that I can read credentials from env vars
  #   Obtain the credentials as expected by AWS, or an AWS Connection
  #   Validate the credentials args?
  #   Test URI variations
  #   Add AWS platform declaration / detection
  #      override platform() in base_connection to force assignment (no detection)
  #      add to platforms/os.rb for family: family api, platform aws

end