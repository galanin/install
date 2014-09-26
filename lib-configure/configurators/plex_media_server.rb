class PuppetConfigurator

  def configure_plex_media_server
    architecture = case RbConfig::CONFIG['host_cpu'] when 'x86_64' then 'amd64' else 'i386' end

    download_page = Internet.download_page('https://plex.tv/downloads')
    plex_download_url_match = %r{(https://downloads.plex.tv/[^"]+#{architecture}\.deb)}.match download_page

    raise 'Plex Media Server: unable to parse download page' unless plex_download_url_match

    plex_download_url = plex_download_url_match[1]
    base_name = File.basename(plex_download_url)

    plex_dir = "#{settings['distribution_dir']}/multimedia/plex"
    FileUtils.mkpath(plex_dir)
    plex_path = "#{plex_dir}/#{base_name}"
    Internet.download_package(plex_download_url, plex_path)

    @config[:plex_media_server] = {
        distribution_path: plex_path,
    }
  end

end