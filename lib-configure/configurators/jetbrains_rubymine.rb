require 'fileutils'

class PuppetConfigurator

  def configure_jetbrains_rubymine
    download_page = Internet.download_page('https://www.jetbrains.com/ruby/download/download_thanks.jsp?os=linux')
    rubymine_download_url_match = %r{<a href="(http://download[^"]+)">HTTP<}.match download_page

    raise "JetBrains RubyMine: unable to parse download page" unless %r{^[:/a-z\d\.\-]+$}i =~ rubymine_download_url_match[1]

    rubymine_download_url = rubymine_download_url_match[1]
    base_name = File.basename(rubymine_download_url)

    rubymine_dir = "#{settings['distribution_dir']}/development/rubymine"
    FileUtils.mkpath(rubymine_dir)
    rubymine_path = "#{rubymine_dir}/#{base_name}"
    Internet.download_package(rubymine_download_url, rubymine_path)
    rubymine_root_folders = File.get_tar_top_folders_name(rubymine_path)

    raise "JetBrains RubyMine: multiple root folders in #{jdk_path}" if rubymine_root_folders.size > 1

    @config[:jetbrains_rubymine] = {
        distribution_path: rubymine_path,
        distribution_name: rubymine_root_folders.first
    }
  end

end