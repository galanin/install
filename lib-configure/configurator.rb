require 'erb'
require 'yaml'

Dir[File.join(File.dirname(__FILE__), 'configurators/*.rb')].each{ |f| require f }

class PuppetConfigurator

  def initialize(settings)
    @settings = YAML.load_file(settings).freeze
    @config = {}
  end

  attr_reader :config, :settings

  def configure_all
    methods.each do |name|
      begin
        send name if name.to_s.index('configure_') == 0 && name != :configure_all
      rescue Exception => e
        puts e.message
      end
    end

    def @config.[](bucket)
      values = super
      def values.[](key)
        return 'undef' if self.nil?
        value = super
        value ? "'#{value}'" : 'undef'
      end
      values
    end

    @config.freeze
  end


  def render_manifest(manifest_template)
    _erbout = nil
    ERB.new(File.read(manifest_template)).result(binding)
    File.write(manifest_template.chomp('.erb'), _erbout)
  end

end
