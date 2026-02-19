#!/usr/bin/env ruby

require 'erb'
require 'fileutils'
require 'yaml'

class TemplateContext
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def tex_bool(value)
    value ? 'true' : 'false'
  end

  def render(template)
    ERB.new(template, trim_mode: '-').result(binding)
  end
end

input_path = ARGV[0] || 'data/cv.yaml'
output_path = ARGV[1] || 'cv.generated.tex'
template_path = ARGV[2] || 'templates/cv.tex.erb'

unless File.exist?(input_path)
  abort("YAML input not found: #{input_path}")
end

unless File.exist?(template_path)
  abort("Template not found: #{template_path}")
end

begin
  raw = YAML.safe_load(File.read(input_path), aliases: false)
rescue Psych::SyntaxError => e
  abort("Failed to parse YAML: #{e.message}")
end

unless raw.is_a?(Hash)
  abort('Top-level YAML structure must be a mapping/object.')
end

%w[document profile footer sections].each do |key|
  abort("Missing required top-level key: #{key}") unless raw.key?(key)
end

context = TemplateContext.new(raw)
rendered = context.render(File.read(template_path))

out_dir = File.dirname(output_path)
FileUtils.mkdir_p(out_dir) unless out_dir == '.'
File.write(output_path, rendered)

puts "Rendered #{output_path} from #{input_path}"
