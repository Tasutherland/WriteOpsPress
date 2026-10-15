#!/usr/bin/env ruby
# frozen_string_literal: true
require "json"
require "yaml"
require "date"

site_dir = ARGV.fetch(0, "_site")
config = YAML.safe_load_file("_config.yml", permitted_classes: [Date, Time], aliases: true)
authors = config.fetch("pen_names")
expected = authors.sum do |author|
  data = YAML.safe_load_file("_data/books_#{author.fetch('data_key')}.yml", permitted_classes: [Date, Time], aliases: true)
  data.count { |book| !book["title"].to_s.strip.empty? }
end

errors = []
# Catch outdated preorder labels when a known release date has passed.
authors.each do |author|
  data = YAML.safe_load_file("_data/books_#{author.fetch('data_key')}.yml", permitted_classes: [Date, Time], aliases: true)
  data.each do |book|
    cover = book["cover"].to_s.sub(%r{\A/}, "")
    if cover.empty? || !File.file?(File.join(site_dir, cover))
      errors << "#{book['title']}: missing book cover asset #{cover.inspect}"
    end

    next unless book["availability"] == "preorder" && book["release_date"]

    release_date = Date.parse(book["release_date"].to_s)
    if release_date <= Date.today
      errors << "#{book['title']}: preorder status remains after #{release_date}"
    end
  end
end

book_files = Dir.glob(File.join(site_dir, "books", "*", "*", "index.html"))
# ASIN-only catalog entries must render real, region-specific Amazon destinations.
# A retailer_url or explicit stores mapping remains valid for wide titles.
regional_hosts = {
  "us" => "www.amazon.com",
  "ca" => "www.amazon.ca",
  "uk" => "www.amazon.co.uk",
  "au" => "www.amazon.com.au"
}
asin_books = authors.flat_map do |author|
  data = YAML.safe_load_file("_data/books_#{author.fetch('data_key')}.yml", permitted_classes: [Date, Time], aliases: true)
  data.select { |book| !book["asin"].to_s.strip.empty? }
end

errors << "Expected #{expected} generated book pages; found #{book_files.length}" if book_files.length != expected
asin_books.each do |book|
  asin = book.fetch("asin").to_s.strip.upcase
  if !/\A[A-Z0-9]{10}\z/.match?(asin)
    errors << "#{book['title']}: malformed ASIN #{asin.inspect}"
    next
  end

  expected_urls = regional_hosts.values.map { |host| "https://#{host}/dp/#{asin}" }
  page = book_files.find do |path|
    body = File.read(path)
    body.include?("<h1>#{book['title']}</h1>")
  end
  unless page
    errors << "#{book['title']}: generated detail page not found"
    next
  end
  html = File.read(page)
  expected_urls.each do |url|
    errors << "#{book['title']}: missing generated link #{url}" unless html.include?(url)
  end
end

# Audiobook editions must be purchasable through the dedicated AUDIOBOOK path,
# never through an ebook URL. Do not add drafting editions to the website.
audio_catalog_path = File.join(site_dir, "audiobooks", "index.html")
audio_editions = YAML.safe_load_file("_data/audiobooks.yml", permitted_classes: [Date, Time], aliases: true)
if !File.file?(audio_catalog_path)
  errors << "Missing audiobook catalog page"
else
  audio_html = File.read(audio_catalog_path)
  audio_editions.each do |edition|
    title = edition["title"].to_s
    url = edition.dig("stores", "kobo").to_s
    errors << "#{title}: audiobook purchase link must point to Canadian English Kobo audio listing" unless url.match?(%r{\Ahttps://www\.kobo\.com/ca/en/audiobook/[a-z0-9-]+\z})
    errors << "#{title}: audio edition link missing from audiobook catalog" unless audio_html.include?(url)
    errors << "#{title}: audiobook ISBN missing" unless edition["isbn"].to_s.match?(/\A\d{13}\z/)
  end
end

# Avoid unintentional retailer links to localized German or non-Canadian stores.
rook_books = YAML.safe_load_file("_data/books_rook.yml", permitted_classes: [Date, Time], aliases: true)
rook_books.select { |book| book["distribution_group"] == "wide" && book["retailer_url"].to_s.include?("kobo.com") }.each do |book|
  unless book["retailer_url"].match?(%r{\Ahttps://www\.kobo\.com/ca/en/ebook/})
    errors << "#{book['title']}: use English Canadian Kobo storefront URL"
  end
end

catalog = File.join(site_dir, "books", "index.html")
errors << "Missing all-books catalog page" unless File.file?(catalog)
sitemap = File.join(site_dir, "sitemap.xml")
errors << "Missing sitemap.xml" unless File.file?(sitemap)
robots = File.join(site_dir, "robots.txt")
errors << "Wrong sitemap domain in robots.txt" unless File.file?(robots) && File.read(robots).include?("Sitemap: https://writeopshq.com/sitemap.xml")

book_files.each do |path|
  html = File.read(path)
  url = path.sub(%r{\A#{Regexp.escape(site_dir)}/?}, "").sub(/index\.html\z/, "")
  errors << "#{url}: missing H1" unless html.match?(/<h1\b/i)
  errors << "#{url}: missing canonical URL" unless html.match?(/<link\s+rel=["']canonical["']/i)
  schemas = html.scan(%r{<script\b[^>]*type=["']application/ld\+json["'][^>]*>(.*?)</script>}im).flatten
  parsed = schemas.filter_map { |s| JSON.parse(s) rescue nil }
  errors << "#{url}: missing valid Book schema" unless parsed.any? { |item| item["@type"] == "Book" }
  errors << "#{url}: not found in sitemap" if File.file?(sitemap) && !File.read(sitemap).include?("/#{url}")
end

Dir.glob(File.join(site_dir, "**", "*.html")).each do |path|
  html = File.read(path)
  if html.match?(/<a\b[^>]*class=["'][^"']*\bbuy-btn\b/i)
    errors << "#{path}: direct retailer anchor has a modal-only buy-btn class"
  end
  html.scan(/href=["'](\/(?:books|series)\/[^"'?#]*\/?)["']/).flatten.uniq.each do |url|
    target = File.join(site_dir, url.sub(%r{\A/}, ""), "index.html")
    errors << "#{path}: broken catalog link #{url}" unless File.file?(target)
  end
end

if errors.any?
  warn "SEO/catalog validation FAILED:"
  errors.each { |message| warn "  - #{message}" }
  exit 1
end
puts "SEO/catalog validation passed: #{expected} book pages, sitemap, canonicals, Book schema and internal links."
