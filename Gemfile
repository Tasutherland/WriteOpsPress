source "https://rubygems.org"

gem "jekyll", "~> 4.3"

# GitHub Pages compatibility (uncomment when deploying)
# gem "github-pages", group: :jekyll_plugins

group :jekyll_plugins do
  gem "jekyll-sitemap"
  gem "jekyll-seo-tag"
end

# Windows and JRuby
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

gem "wdm", "~> 0.1", platforms: %i[mingw x64_mingw mswin]
gem "http_parser.rb", "~> 0.6.0", platforms: :jruby
