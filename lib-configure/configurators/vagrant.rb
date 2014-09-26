class PuppetConfigurator

  def configure_vagrant
    architecture = case RbConfig::CONFIG['host_cpu'] when 'x86_64' then 'x86_64' else 'i686' end

    download_page = Internet.download_page('http://www.vagrantup.com/downloads.html')

    vagrant_match = %r{https://[a-z\./]*?/(vagrant_([\d\.]+)_#{architecture}\.deb)}.match download_page

    raise 'Vagrant: unable to parse version' unless vagrant_match

    vagrant_download_url = vagrant_match[0]
    base_name = vagrant_match[1]

    vagrant_dir = "#{settings['distribution_dir']}/development/vagrant"
    FileUtils.mkpath(vagrant_dir)
    vagrant_path = "#{vagrant_dir}/#{base_name}"
    Internet.download_package(vagrant_download_url, vagrant_path)

    @config[:vagrant] = {
        distribution_path: vagrant_path,
    }
  end

end