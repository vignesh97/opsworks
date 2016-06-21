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