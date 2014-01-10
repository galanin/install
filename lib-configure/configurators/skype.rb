require 'fileutils'

class PuppetConfigurator

  def configure_skype
    skype_download_url = Internet.fetch_location('http://www.skype.com/go/getskype-linux-ubuntu-64')
    package_name = File.basename(skype_download_url)

    skype_dir = "#{settings['distribution_dir']}/network"
    FileUtils.mkpath(skype_dir)

    skype_path = "#{skype_dir}/#{package_name}"
    Internet.download_package(skype_download_url, skype_path)
    @config[:skype] = {
        distribution_path: skype_path
    }
  end
end