# frozen_string_literal: true

# Build permanent book and multi-book series URLs from the existing YAML catalog.
# No manual page creation is required when new books are added to _data/books_*.yml.
module WriteOps
  class CatalogPages < Jekyll::Generator
    safe true
    priority :normal

    def generate(site)
      authors = Array(site.config["pen_names"])
      all_books = []
      series_groups = Hash.new { |hash, key| hash[key] = [] }
      seen_paths = {}

      authors.each do |author|
        data_key = "books_#{author.fetch('data_key')}"
        books = site.data[data_key]
        next unless books.is_a?(Array)

        books.each do |book|
          next if book["title"].to_s.strip.empty?

          slug = Jekyll::Utils.slugify(book["title"])
          raise "Empty slug for #{data_key}: #{book['title']}" if slug.empty?

          path = "/books/#{author.fetch('id')}/#{slug}/"
          raise "Duplicate book URL: #{path}" if seen_paths[path]

          seen_paths[path] = true
          book["detail_url"] = path
          book["pen_id"] = author["id"]
          book["pen_name"] = author["name"]
          book["author_url"] = "/authors/#{author['id']}/"

          # ASIN-only KDP entries expand to the four usual Amazon storefronts.
          # Explicit store URLs (including wide retailers) remain authoritative.
          asin = book["asin"].to_s.strip.upcase
          unless asin.empty?
            unless /\A[A-Z0-9]{10}\z/.match?(asin)
              raise "Invalid ASIN for #{data_key}: #{book['title']} (#{asin})"
            end

            standard_stores = {
              "us" => "https://www.amazon.com/dp/#{asin}",
              "ca" => "https://www.amazon.ca/dp/#{asin}",
              "uk" => "https://www.amazon.co.uk/dp/#{asin}",
              "au" => "https://www.amazon.com.au/dp/#{asin}"
            }
            custom_stores = book["stores"].is_a?(Hash) ? book["stores"] : {}
            book["stores"] = standard_stores.merge(custom_stores)
            book["asin"] = asin
          end

          series = book["series"].to_s.sub(/\s+#\d+\s*\z/, "").strip
          book["series_name"] = series unless series.empty?
          series_groups[[author["id"], series]] << book unless series.empty?
          all_books << [author, book]
        end
      end

      # Enrich released audiobook editions with the existing ebook/catalog data.
      # Edition identity is by Work ID, not title matching or ISBN guessing.
      indexed_books = all_books.each_with_object({}) do |(_author, book), index|
        work_id = book["work_id"].to_s
        index[work_id] = book unless work_id.empty?
      end
      Array(site.data["audiobooks"]).each do |audio|
        book = indexed_books[audio["work_id"].to_s]
        raise "Audiobook has no matching catalog work: #{audio['title']}" unless book
        raise "Audiobook title mismatch: #{audio['title']}" unless audio["title"] == book["title"]

        audio["book_url"] = book["detail_url"]
        audio["pen_name"] = book["pen_name"]
        audio["cover"] = book["cover"]
        book["audiobook"] = audio
      end

      series_groups.each do |(author_id, series_name), books|
        next if books.length < 2

        slug = Jekyll::Utils.slugify(series_name)
        path = "/series/#{author_id}/#{slug}/"
        books.each { |book| book["series_url"] = path }
        author = authors.find { |entry| entry["id"] == author_id }
        ordered = ordered_books(books)

        page = Jekyll::PageWithoutAFile.new(site, site.source, "series/#{author_id}/#{slug}", "index.html")
        page.data.merge!(
          "layout" => "series",
          "title" => "#{series_name} books by #{author['name']}",
          "description" => "Explore the #{series_name} romance series by #{author['name']}, including titles, reading order and retailer links.",
          "series_name" => series_name,
          "pen_name" => author["name"],
          "pen_id" => author_id,
          "author_url" => "/authors/#{author_id}/",
          "series_books" => ordered
        )
        site.pages << page
      end

      all_books.each do |author, book|
        slug = Jekyll::Utils.slugify(book["title"])
        dir = "books/#{author['id']}/#{slug}"
        page = Jekyll::PageWithoutAFile.new(site, site.source, dir, "index.html")
        related = series_groups[[author["id"], book["series_name"]]].to_a
        page.data.merge!(
          "layout" => "book",
          "title" => "#{book['title']} by #{author['name']}",
          "description" => book["blurb"].to_s.empty? ? book["hook"].to_s : book["blurb"].to_s,
          "pen_name" => author["name"],
          "pen_id" => author["id"],
          "pen_promise" => author["promise"],
          "author_url" => book["author_url"],
          "book" => book,
          "series_books" => ordered_books(related),
          "image" => book["cover"].to_s.empty? ? nil : "/#{book['cover'].sub(%r{\A/}, '')}"
        )
        site.pages << page
      end
    end

    private

    def ordered_books(books)
      books.sort_by do |book|
        number = book["series"].to_s[/#(\d+)\s*\z/, 1]
        [number ? number.to_i : 9999, book["title"].to_s]
      end
    end
  end
end
