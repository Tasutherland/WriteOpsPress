#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'pathname'

ROOT = Pathname.new(__dir__).join('..').expand_path
DATA_GLOB = ROOT.join('_data', 'books_*.yml').to_s
REQUIRED_REGIONS = %w[ca us uk au].freeze
VALID_DISTRIBUTION_GROUPS = %w[amazon-ku wide].freeze
EXPECTED_ACTIVE_AUTHORS = ['Rook Brennan', 'Ash Wilder', 'M. Farrow', 'Rita Dole'].freeze
EXPECTED_FEATURED_TITLES = {
  'books_rook.yml' => [
    'Full Contact',
    'Oops, I Dated a Werewolf',
    'Captured by the Enforcer',
    "Shadow's Cage",
    'Monster on the Rim',
    'Made for the Spider Beast',
    'Made for the Chimera'
  ],
  'books_ash.yml' => [
    'Make Room',
    "Good Boys Don't Share",
    'The Ad for Silence',
    'Velvet Restraint',
    'Backstage Obedience'
  ],
  'books_rita.yml' => [
    'The Demon’s Broken Crown',
    'The Demon’s Prize Wager',
    'The Key and the Claim',
    "Monster's Marriage Clause",
    'The Auctioneer’s Claim'
  ],
  'books_farrow.yml' => [
    'Hexed by the Demon Lord',
    'Revel of Monsters',
    'Wanted by the Hungry Hollow'
  ],
  'books_eve.yml' => []
}.freeze
EXPECTED_ROOK_GROUPS = {
  'amazon-ku' => [
    'Full Contact',
    'Oops, I Dated a Werewolf',
    'Captured by the Enforcer',
    "Shadow's Cage",
    'Monster on the Rim'
  ],
  'wide' => ['Made for the Spider Beast', 'Made for the Chimera']
}.freeze
PUBLIC_SOURCE_GLOBS = [
  '*.md',
  '_includes/*.html',
  '_layouts/*.html',
  'assets/css/*.css',
  'assets/js/*.js',
  'pen-names/*.md'
].freeze
NEWSLETTER_MARKERS = ['mailerlite', '/newsletter/', 'pen-newsletter', 'mailerlite-form'].freeze

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

  filename = Pathname.new(file_path).basename.to_s
  expected_featured = EXPECTED_FEATURED_TITLES[filename]
  if expected_featured
    actual_featured = data.select { |book| book.is_a?(Hash) && book['featured'] == true }
                          .map { |book| book['title'] }
    missing_featured = expected_featured - actual_featured
    unexpected_featured = actual_featured - expected_featured
    errors << "#{relative_file}: missing intended featured titles: #{missing_featured.join(', ')}" unless missing_featured.empty?
    errors << "#{relative_file}: unexpected featured titles: #{unexpected_featured.join(', ')}" unless unexpected_featured.empty?
  end

  if filename == 'books_rook.yml'
    EXPECTED_ROOK_GROUPS.each do |group, expected_titles|
      actual_titles = data.select do |book|
        book.is_a?(Hash) && book['featured'] == true && book['distribution_group'] == group
      end.sort_by { |book| book['featured_order'] }.map { |book| book['title'] }
      unless actual_titles == expected_titles
        errors << "#{relative_file}: #{group} featured order should be #{expected_titles.join(', ')}"
      end
    end
  end

  seen_work_ids = {}
  seen_titles = {}

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

    unless blank_string?(title)
      normalized_title = title.to_s.downcase.strip
      if seen_titles.key?(normalized_title)
        errors << "#{prefix}: duplicate canonical title (also book ##{seen_titles[normalized_title]})"
      else
        seen_titles[normalized_title] = book_num
      end
    end

    work_id = book['work_id']
    unless blank_string?(work_id)
      if seen_work_ids.key?(work_id)
        errors << "#{prefix}: duplicate work_id '#{work_id}' (also book ##{seen_work_ids[work_id]})"
      else
        seen_work_ids[work_id] = book_num
      end
    end

    cover = book['cover']
    if blank_string?(cover)
      errors << "#{prefix}: missing or empty cover"
    else
      cover_path = ROOT.join(cover)
      errors << "#{prefix}: cover file not found at '#{cover}'" unless cover_path.file?
    end

    stores = book['stores']

    if book['featured'] == true
      featured_order = book['featured_order']
      errors << "#{prefix}: featured books need a numeric featured_order" unless featured_order.is_a?(Numeric)

      distribution_group = book['distribution_group']
      unless VALID_DISTRIBUTION_GROUPS.include?(distribution_group)
        errors << "#{prefix}: featured books need distribution_group amazon-ku or wide"
      end

      if title.to_s.match?(/\A\s*\d+[a-z]?\s*-/i) || title.to_s.match?(/alt title|make\.com/i)
        errors << "#{prefix}: featured title contains internal planning text"
      end
    end

    retailer_url = book['retailer_url']
    if !blank_string?(retailer_url) && !retailer_url.to_s.start_with?('https://')
      errors << "#{prefix}: retailer_url must start with https://"
    end

    next if stores.nil?

    unless stores.is_a?(Hash)
      errors << "#{prefix}: stores must be a mapping/object when present"
      next
    end

    if book['distribution_group'] == 'amazon-ku'
      REQUIRED_REGIONS.each do |region|
        if blank_string?(stores[region])
          errors << "#{prefix}: missing required Amazon store region '#{region}'"
        end
      end
    end

    stores.each do |region, url|
      next if blank_string?(url)
      next if url.to_s.start_with?('https://')

      errors << "#{prefix}: store URL for '#{region}' must start with https:// (got '#{url}')"
    end
  end
end

begin
  config = load_yaml_file(ROOT.join('_config.yml'))
  active_authors = config.fetch('pen_names', []).map { |author| author['name'] }
  unless active_authors == EXPECTED_ACTIVE_AUTHORS
    errors << "_config.yml: active authors should be #{EXPECTED_ACTIVE_AUTHORS.join(', ')}"
  end
rescue Psych::SyntaxError => e
  errors << "_config.yml: YAML parse error: #{e.message.lines.first.strip}"
rescue StandardError => e
  errors << "_config.yml: YAML load error: #{e.class}: #{e.message}"
end

eve_legacy_page = ROOT.join('pen-names', 'eve-hartley.md')
if eve_legacy_page.file?
  eve_source = eve_legacy_page.read
  unless eve_source.include?('permalink: /authors/eve-hartley/')
    errors << 'pen-names/eve-hartley.md: legacy permalink changed or missing'
  end
  unless eve_source.include?('sitemap: false')
    errors << 'pen-names/eve-hartley.md: legacy page should be excluded from the sitemap'
  end
  if eve_source.include?('featured-books.html')
    errors << 'pen-names/eve-hartley.md: legacy page should not render featured books'
  end
else
  errors << 'pen-names/eve-hartley.md: legacy route file is missing'
end

PUBLIC_SOURCE_GLOBS.each do |source_glob|
  Dir.glob(ROOT.join(source_glob).to_s).each do |source_path|
    source = File.read(source_path)
    NEWSLETTER_MARKERS.each do |marker|
      next unless source.downcase.include?(marker.downcase)

      relative_source = Pathname.new(source_path).relative_path_from(ROOT).to_s
      errors << "#{relative_source}: public newsletter reference remains ('#{marker}')"
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
