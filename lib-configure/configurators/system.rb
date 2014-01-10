class PuppetConfigurator

  def configure_system
    @config[:system] = {
        codename: `lsb_release -sc`.chomp
    }
  end

end