class PuppetConfigurator

  def configure_oracle_java
    download_page = Internet.download_page('http://www.oracle.com/technetwork/java/javase/downloads/index.html')
    jdk_download_page_match = %r{<a[^>]*href="([^"]+)"><img[^>]*Download JDK}.match download_page

    raise "Oracle Java: unable to parse main download page" unless %r{^[/a-z\d\.\-]+$} =~ jdk_download_page_match[1]

    jdk_download_page = Internet.download_page('http://www.oracle.com' + jdk_download_page_match[1])
    architecture = case RbConfig::CONFIG['host_cpu'] when 'x86_64' then 'x64' else 'i586' end
    jdk_download_url_match = %r{(http://download.*/([^/]+)/(\w+-(.*)-linux-#{architecture}\.tar\.gz))}.match(jdk_download_page)

    raise "Oracle Java: unable to parse JDK download page" unless jdk_download_url_match

    url       = jdk_download_url_match[1]
    build     = jdk_download_url_match[2]
    base_name = jdk_download_url_match[3]

    jdk_path = "#{settings['distribution_dir']}/java/jdk/#{build}/#{base_name}"
    Internet.download_package(url, jdk_path, ['Cookie: gpw_e24=h'])
    jdk_root_folders = File.get_tar_top_folders_name(jdk_path)

    raise "Oracle Java: multiple root folders in #{jdk_path}" if jdk_root_folders.size > 1

    @config[:oracle_jdk] = {
        distribution_path: jdk_path,
        distribution_name: jdk_root_folders.first
    }
  end

end