class PuppetConfigurator

  def configure_virtualbox
    download_page = Internet.download_page('https://www.virtualbox.org/wiki/Downloads')

    virtualbox_version_match = %r{VirtualBox (\d.\d+)(?:.\d+)? for Linux hosts}.match download_page

    raise "Virtualbox: unable to parse version" unless virtualbox_version_match[1]

    version = virtualbox_version_match[1]

    extpack_download_url_match = %r{href="(http://download[^"]+#{version}[^"]+\.vbox-extpack)"}.match download_page

    raise "Virtualbox: unable to parse download page" unless extpack_download_url_match[1]

    extpack_download_url = extpack_download_url_match[1]
    base_name = File.basename(extpack_download_url)

    extpack_dir = "#{settings['distribution_dir']}/utilities"
    FileUtils.mkpath(extpack_dir)
    extpack_path = "#{extpack_dir}/#{base_name}"
    Internet.download_package(extpack_download_url, extpack_path)

    @config[:virtualbox] = {
        version:      version,
        extpack_path: extpack_path,
    }
  end

end