#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'pathname'

ROOT = Pathname.new(__dir__).join('..').expand_path
DATA_GLOB = ROOT.join('_data', 'books_*.yml').to_s
REQUIRED_REGIONS = %w[ca us uk au].freeze

errors = []

# Prefer safe YAML loading for plain data structures.
def load_yaml_file(path)
  if YAML.respond_to?(:safe_load_file)
    YAML.safe_load_file(path, permitted_classes: [], permitted_symbols: [], aliases: false)
  else
    YAML.safe_load(File.read(path), permitted_classes: [], permitted_symbols: [], aliases: false)
  end
end

def blank_string?(value)
  value.nil? || value.to_s.strip.empty?
end

book_files = Dir.glob(DATA_GLOB).sort

if book_files.empty?
  puts "Book validation failed: no files matched #{DATA_GLOB.inspect}"
  exit 1
end

book_files.each do |file_path|
  relative_file = Pathname.new(file_path).relative_path_from(ROOT).to_s

  begin
    data = load_yaml_file(file_path)
  rescue Psych::SyntaxError => e
    errors << "#{relative_file}: YAML parse error: #{e.message.lines.first.strip}"
    next
  rescue StandardError => e
    errors << "#{relative_file}: YAML load error: #{e.class}: #{e.message}"
    next
  end

  unless data.is_a?(Array)
    errors << "#{relative_file}: expected top-level YAML array of books, got #{data.class}"
    next
  end

  data.each_with_index do |book, index|
    book_num = index + 1
    book_title = book.is_a?(Hash) ? book['title'] : nil
    display_title = blank_string?(book_title) ? '<no title>' : book_title
    prefix = "#{relative_file} [book ##{book_num} \"#{display_title}\"]"

    unless book.is_a?(Hash)
      errors << "#{prefix}: expected book entry to be a mapping/object, got #{book.class}"
      next
    end

    title = book['title']
    errors << "#{prefix}: missing or empty title" if blank_string?(title)

    cover = book['cover']
    if blank_string?(cover)
      errors << "#{prefix}: missing or empty cover"
    else
      cover_path = ROOT.join(cover)
      errors << "#{prefix}: cover file not found at '#{cover}'" unless cover_path.file?
    end

    stores = book['stores']
    next if stores.nil?

    unless stores.is_a?(Hash)
      errors << "#{prefix}: stores must be a mapping/object when present"
      next
    end

    REQUIRED_REGIONS.each do |region|
      if blank_string?(stores[region])
        errors << "#{prefix}: missing required store region '#{region}'"
      end
    end

    stores.each do |region, url|
      next if blank_string?(url)
      next if url.to_s.start_with?('https://')

      errors << "#{prefix}: store URL for '#{region}' must start with https:// (got '#{url}')"
    end
  end
end

if errors.empty?
  puts 'Book validation passed: no errors found.'
  exit 0
else
  puts 'Book validation failed with errors:'
  errors.each { |error| puts "- #{error}" }
  exit 1
end
