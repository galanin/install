#!/usr/bin/env ruby

TOOL_BASE_DIR = File.dirname(File.expand_path($0))
LIB_DIR       = "#{TOOL_BASE_DIR}/lib-configure"
FILES_DIR     = "#{TOOL_BASE_DIR}/files"
CACHE_DIR     = "#{FILES_DIR}/cache"
MANIFESTS_DIR = "#{TOOL_BASE_DIR}/manifests"

require "#{LIB_DIR}/configurator"
require "#{LIB_DIR}/internet"
require "#{LIB_DIR}/file"

configurator = PuppetConfigurator.new("#{TOOL_BASE_DIR}/settings.yml")

configurator.configure_all
configurator.render_manifest("#{TOOL_BASE_DIR}/common.pp.erb")
