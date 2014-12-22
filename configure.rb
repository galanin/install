#!/usr/bin/env ruby

CONFIGURE_REGEXP = /^\s*#\s*configure:\s*(\S+)$/

TOOL_BASE_DIR = File.dirname(File.expand_path($0))
LIB_DIR       = "#{TOOL_BASE_DIR}/lib-configure"
FILES_DIR     = "#{TOOL_BASE_DIR}/files"
CACHE_DIR     = "#{FILES_DIR}/cache"
MANIFESTS_DIR = "#{TOOL_BASE_DIR}/manifests"

require "#{LIB_DIR}/configurator"
require "#{LIB_DIR}/internet"
require "#{LIB_DIR}/file"

configurator = PuppetConfigurator.new("#{TOOL_BASE_DIR}/settings.yml")

manifests = ARGV.map {|m| "#{TOOL_BASE_DIR}/#{m}.pp.erb"}
parts = manifests.map do |m|
  IO.readlines(m).grep(CONFIGURE_REGEXP).map { |p| p =~ CONFIGURE_REGEXP; $~[1] }
end.reduce(&:+).uniq + ['system']

configurator.configure(parts)

manifests.each { |m| configurator.render_manifest(m) }
