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
  featured: false                  # set true to show in Start Here
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
newsletter.md
privacy.md
contact.md
```

## MailerLite

The global signup form (account `1929203`, form `181146944483100052`) is embedded in:
- `newsletter.md` (full embed)
- `index.md` (full embed)
- Each pen-name page (popup trigger via `.ml-onclick-form` button)

To update the form, replace the HTML in `_includes/mailerlite-form.html`.

## Custom Domain

1. Add a `CNAME` file at the repo root containing your domain (e.g. `writeopspress.com`).
2. Configure DNS: add a CNAME record pointing to `<your-github-username>.github.io`.
3. Enable HTTPS in the GitHub Pages settings.

## Quality Checklist Before Publishing

- [ ] Test on mobile width (375px and 430px)
- [ ] Click every Buy link for CA, US, and UK
- [ ] Confirm MailerLite form submits and redirects correctly
- [ ] Check Open Graph images appear when sharing on social
- [ ] Validate sitemap at `/sitemap.xml`
