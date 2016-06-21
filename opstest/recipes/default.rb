Chef::Log.info("******Creating a data directory.******")

data_dir = value_for_platform(
  "centos" => { "default" => "/srv/www/shared" },
  "ubuntu" => { "default" => "/srv/www/data" },
  "default" => "/srv/www/config"
)

directory data_dir do
  mode 0755
  owner 'root'
  group 'root'
  recursive true
  action :create
end
=begin
gem_package "aws-sdk" do
  action :install
end

ruby_block "download-object" do
  block do
    require 'aws-sdk'

    s3 = AWS::S3.new

    myfile = s3.buckets['dev.rivet.media.bucket'].objects['test.txt']
    Dir.chdir("/tmp")
    File.open("test.txt", "w") do |f|
      f.syswrite(myfile.read)
      f.close
    end
  end
  action :run
end
=end

chef_gem "aws-sdk" do
  compile_time false
end

# Define that aws-sdk is required
require 'aws-sdk'
# Declare the s3 object as an S3 client
s3 = Aws::S3::Client.new(region:'us-east-1')

# Set bucket and object name
obj = s3.get_object(bucket:'dev.rivet.media.web', key:'test.txt')

# Read content to variable
content = obj.body.read
Chef::Log.info(content)

# Log output (optional)

# Write the S3 content to file (in /tmp)
file '/tmp/test.txt' do
  owner 'root'
  group 'root'
  mode '0755'
  content content
  action :create
end
