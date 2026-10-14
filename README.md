# WriteOps Press Website

Static site built with [Jekyll](https://jekyllrb.com/) and hosted on [GitHub Pages](https://pages.github.com/).

## Quick Start (local development)

```bash
bundle install
bundle exec jekyll serve --livereload
```

Open `http://localhost:4000` in your browser.


## Project Notes for Beginners

If you're new to this repo, here are the basics in plain language:

- **What kind of project this is:** This is a static website built with Jekyll and hosted on GitHub Pages. The site is generated from templates and content files; there is no custom backend server in this repo.
- **Where book data lives:** Book listings live in YAML files inside `_data/`, such as `_data/books_ash.yml` and other `books_<pen>.yml` files.
- **Where author pages live:** Author pages live in the `pen-names/` folder, with one Markdown file per pen name.
- **How to preview the site locally:** Run `bundle install`, then run `bundle exec jekyll serve --livereload`, and open `http://localhost:4000`.
- **What files should be edited carefully:** Edit `_config.yml`, `_layouts/`, and shared `_includes/` carefully because changes there can affect many pages at once.

## Adding a New Book

1. **Export/resize the cover** to WEBP (or JPG fallback), target under 200KB.
   Place it in `assets/covers/<pen>/` (e.g. `assets/covers/ash/my-book.webp`).

2. **Add an entry** to the pen's data file (`_data/books_<pen>.yml`):

```yaml
- title: "Book Title"
  series: "Series Name #1"        # optional
  hook: "One-line hook (~150 chars)."
  blurb: "2–4 sentence short blurb."
  cover: "assets/covers/ash/my-book.webp"
  featured: true                   # shown in curated author shelves; all books get detail pages
  featured_order: 1                # display order within the curated shelf
  distribution_group: amazon-ku    # amazon-ku or wide
  stores:
    ca: "https://www.amazon.ca/dp/ASIN"
    us: "https://www.amazon.com/dp/ASIN"
    uk: "https://www.amazon.co.uk/dp/ASIN"
    au: "https://www.amazon.com.au/dp/ASIN"
```

3. **Commit and push** to GitHub. GitHub Pages rebuilds automatically (~1 min).

## Site Structure

```
_config.yml          — Jekyll config, pen name definitions
_data/               — YAML book data per pen name
_includes/           — Reusable HTML partials
_layouts/            — Page templates (default, pen-name)
assets/
  css/main.css       — All styles
  js/main.js         — Nav toggle + buy modal
  covers/<pen>/      — Book cover images (add yours here)
  img/               — Logos, OG images, favicon
pen-names/           — One .md file per pen name
index.md             — Press home page
privacy.md
contact.md
```

For a wide-release book, set `distribution_group: wide`. Add a verified `retailer_url`
(such as a universal retailer page) or a `stores` mapping when one is available. A featured
book can remain visible without a retailer URL; use `availability: retailer-links-pending`
to show that state. Never add a placeholder retailer URL. Unfeatured catalog entries remain in the YAML file and appear in the complete book catalog at /books/ as well as on their own detail pages. Promote them to the featured author shelves by setting featured: true.

## Automatic book and series pages / SEO

- The custom generator at `_plugins/catalog_pages.rb` builds a permanent
  `/books/<pen-name>/<book-title>/` page for every book in the four active
  pen-name YAML files. Every book appears on `/books/`, even if not featured.
- Series with two or more listed books also get permanent `/series/<pen>/<series>/`
  pages, with reading-order links. The feature shelves remain curated.
- The existing book `hook` is used as a search description and reader-facing
  teaser. Add an optional `blurb` for fuller text on a book page. Book pages
  include Book JSON-LD, cover OG images (when a cover is present), canonical URLs,
  and verified retailer links only.
- To verify locally: `bundle exec jekyll build` and
  `ruby scripts/validate_seo.rb _site`. The GitHub Pages workflow runs both.
- Keep `_config.yml` > `url`, `CNAME`, and `robots.txt` on the same
  public domain (`https://writeopshq.com`).
- After deployment, verify the domain and submit `https://writeopshq.com/sitemap.xml`
  in Google Search Console. Monitor indexed pages, branded searches, and
  retailer click-throughs before adding optional analytics.
- New titles only require an entry in `_data/books_*.yml`. Ensure the cover
  file exists, the hook is accurate, and retailer URLs are verified before
  publishing; do not invent or guess retailer URLs.

## Custom Domain

1. Add a `CNAME` file at the repo root containing your domain (e.g. `writeopspress.com`).
2. Configure DNS: add a CNAME record pointing to `<your-github-username>.github.io`.
3. Enable HTTPS in the GitHub Pages settings.

## Quality Checklist Before Publishing

- [ ] Test on mobile width (375px and 430px)
- [ ] Click every Buy link for CA, US, and UK
- [ ] Confirm only curated featured books appear on each active author page
- [ ] Check Open Graph images appear when sharing on social
- [ ] Validate sitemap at `/sitemap.xml`
