require 'digest/md5'
require 'open-uri'
require 'fileutils'
require 'net/http'
require 'tmpdir'

class Internet

  def self.download_page(url)
    cache_file_name = Digest::MD5.hexdigest(url)
    cache_file_path = "#{CACHE_DIR}/#{cache_file_name}"
    if !File.exists?(cache_file_path) || Time.now - File.ctime(cache_file_path) > 24*3600
      begin
        content = open(url).read
        File.write(cache_file_path, content)
        puts "Download page: #{url}"
      rescue
        puts "Unable to download: #{url}"
        raise
      end
    else
      content = File.read(cache_file_path)
    end
    content
  end

  def self.download_package(url, local_path, headers = [])
    if !File.exists?(local_path)
      Dir.mktmpdir do |dir|
        temp_path = File.join(dir, File.basename(local_path))
        headers_string = Array === headers ? headers.join("\n") : headers.to_s
        headers_param = headers_string.empty? ? '' : "--header '#{headers_string}'"
        puts "Download to #{temp_path}"
        result = system("curl -fLC - --retry 3 --retry-delay 3 #{headers_param} -o #{temp_path} #{url}")
        unless result && $?.exitstatus == 0
          raise "Can't download #{url}"
        end
        FileUtils.mkpath(File.dirname(local_path))
        puts "Move to #{local_path}"
        FileUtils.mv(temp_path, local_path)
      end
    else
      puts "Already downloaded: #{local_path}"
    end
  end

  def self.fetch_location(url)
    cache_file_name = Digest::MD5.hexdigest(url)
    cache_file_path = "#{CACHE_DIR}/#{cache_file_name}"
    if !File.exists?(cache_file_path) || Time.now - File.ctime(cache_file_path) > 7*24*3600
      puts "Fetch location for: #{url}"
      uri = URI(url)
      Net::HTTP.start(uri.host, uri.port) {|http|
        location = http.head(uri.path)['Location']
        File.write(cache_file_path, location)
        location
      }
    else
      File.read(cache_file_path)
    end
  end

end
