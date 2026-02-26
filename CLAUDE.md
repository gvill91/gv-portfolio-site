# GV Portfolio — Claude Code Context

## Project Overview
Personal portfolio and blog for Genaro, a Senior Macro & Housing Economist at Freddie Mac
and data visualization specialist. The site showcases projects spanning housing economics,
data viz, and other topics of personal interest.

**Stack:** React 19 + Vite 7. No UI libraries — plain CSS only.
**Dev server:** `npm run dev` → http://localhost:5173

> **Start of every session:** run `npm run dev` in the project root and leave it running.
> This serves the site at localhost:5173. Nothing works without it.

---

## File Structure

```
gv-portfolio/
├── public/
│   ├── logo.svg          # GV logo (SVG, used in navbar)
│   ├── logo.png          # Original PNG logo (reference only)
│   ├── profile.jpg       # Profile photo for hero section (user to add)
│   ├── mortgage-rates-thumb.png  # Card thumbnail for mortgage rates project
│   └── widgets/
│       ├── mortgage-rates-beeswarm.html        # R-generated ggiraph widget
│       └── mortgage-rates-beeswarm_files/      # JS/CSS dependencies for widget
├── projects/
│   └── mortgage-rates-beeswarm/
│       ├── beeswarm.R    # R script — run manually to regenerate widget HTML
│       └── R File.txt    # Original prototype script (reference only)
├── src/
│   ├── App.jsx           # All React components + routing
│   ├── App.css           # All component styles
│   ├── index.css         # Global reset, CSS custom properties
│   └── main.jsx          # React entry point
├── vite.config.js        # Vite config (React plugin only)
└── index.html            # HTML shell (includes Wix Madefor Text via Google Fonts)
```

---

## Brand Colors

All colors are defined as CSS custom properties in `src/index.css`.

| Token          | Hex                        | Usage                                        |
|----------------|----------------------------|----------------------------------------------|
| `--bg`         | `#F5ECD7`                  | Main page background (warm sandy yellow)     |
| `--bg-card`    | `#ffffff`                  | Card backgrounds                             |
| `--bg-nav`     | `#2A3531`                  | Navbar background (darkest logo color)       |
| `--text`       | `#2A3531`                  | All body text                                |
| `--text-muted` | `#7A6E5D`                  | Secondary/muted text                         |
| `--accent`     | `#CD2922`                  | Primary accent — hover states                |
| `--accent-sec` | `#13A29C`                  | Secondary accent — links, card hover border  |
| `--border`     | `#DDD0B8`                  | Borders (warm sandy tone)                    |
| `--max-w`      | `960px`                    | Max content width                            |

### GV Logo / Brand Palette
The official logo is `public/banner.svg` — a Mexican blanket-inspired horizontal banner
with "GV" in solid `#2A3531` on a sandy center field, flanked by 11 equal-width (22px)
vertical color stripes on each side. These stripe colors ARE the brand palette:

| Position | Hex       | Description     |
|----------|-----------|-----------------|
| Outer    | `#1A1A1A` | Near black       |
|          | `#1B6540` | Forest green     |
|          | `#0D8070` | Dark teal        |
|          | `#18B0C8` | Bright turquoise |
|          | `#E8C010` | Golden yellow    |
|          | `#F07028` | Orange           |
|          | `#C81818` | Crimson red      |
|          | `#7A1820` | Dark maroon      |
|          | `#383838` | Charcoal         |
|          | `#909090` | Gray             |
| Inner    | `#C8BAA0` | Warm cream       |

Center field: `#F5ECD7` (sandy yellow). GV text: `#2A3531` (dark green).

Note: `public/logo.svg` (navbar logo) uses an older stripe palette and may need
updating to align with the official brand colors above.

---

## Typography

**Font:** Wix Madefor Text (Google Fonts), loaded via `<link>` in `index.html`.
Weights loaded: 400, 500, 600, 700, 800 (italic 400 also included).
Fallback: `system-ui, -apple-system, sans-serif`.

---

## Logo (`public/logo.svg`)

Built with SVG `<clipPath>` + colored `<rect>` stripes. Structure:
- A `<clipPath>` contains a `<text>` element ("GV", Arial Black 280px) that masks the stripes
- A white `<text>` element drawn first at the same position creates a subtle outline trim
- 7 `<rect>` elements filled with the stripe colors, each using `clip-path="url(#gv-clip)"`
- `viewBox="0 -10 560 240"` — width=560, height=240, aspect ratio = 560/240 ≈ 2.333
- Stripes span `y=5` to `y=205` (estimated cap-top to baseline for this font/size)
- Each stripe is `28.6px` tall (`200px ÷ 7`)
- White outline uses `stroke-width="14"` on the background text element (full opacity, no transparency)

---

## Design Conventions

- **Minimal, modern, uplifting** — warm sandy background, white cards, clean type
- **Typography:** Wix Madefor Text; nav links `font-weight: 500`
- **Navbar:** sticky, 64px tall, `#2A3531` dark background, nav links in dimmed sandy
  (`rgba(245, 236, 215, 0.7)`) at rest → full sandy (`#F5ECD7`) on hover. No border-bottom
  (the stark color contrast with the sandy page defines the edge naturally).
- **Hero:** two-column flex layout — intro text left, circular profile photo right (220px).
  Stacks vertically on mobile (<640px), photo above text. No border-bottom on the section.
- **Projects:** separated from hero by `border-top: 1px solid var(--border)`
- **Cards:** white (`--bg-card`) on sandy background. Subtle resting shadow. Teal (`--accent-sec`)
  border + stronger lift + shadow on hover. Thumbnail zooms (scale 1.04) on hover. "View Project →"
  link in teal, turns red on hover. Full card is clickable via `card-link::after { position: absolute; inset: 0 }`
- **Global links:** default `--accent-sec` (teal), hover `--accent` (red)
- **Charts/embeds:** white card backgrounds complement lighter chart backgrounds well

### Project Detail Pages
Each project has a dedicated route and React component. Structure:
- Date, title, 1–2 body paragraphs (the story/context), full-width iframe widget, tags
- The `<iframe>` embeds the R-generated widget from `public/widgets/`
- Charts include a dark footer strip (`gv_dark` / `#2A3531`) at the bottom matching the
  navbar, which gives the GV logo white trim strong contrast against the dark background
- Tags are rendered as pill spans with class `project-tag`

---

## Site Structure & Components (all in `src/App.jsx`)

React Router is set up with `<Routes>` / `<Route>`. All routes are in `App.jsx`.

| Component           | Route                      | Description                                         |
|---------------------|----------------------------|-----------------------------------------------------|
| `Navbar`            | (shared)                   | Sticky top nav with logo + Home / Projects / About  |
| `Hero`              | (home only)                | Intro text + circular profile photo                 |
| `Projects`          | (home only)                | 3-column responsive project card grid               |
| `ProjectCard`       | (home only)                | Card: thumbnail, title, description, link           |
| `MortgageRatesPage` | `/projects/mortgage-rates` | Beeswarm chart project detail page                  |
| `App`               | root                       | Router — `/` renders home, project routes render pages |

### Project Data (`PROJECTS` array in `App.jsx`)
Each project: `{ id, title, description, href, thumb }`
- `thumb`: path to image in `public/` (e.g. `'/mortgage-rates-thumb.png'`)
- If no `thumb`, card falls back to a `thumbBg` colored placeholder div

Current projects:
1. **Mortgage Rate Dispersion** — `/projects/mortgage-rates` — Interactive beeswarm chart of 30Y fixed rates by year

### Nav Links
`Home` (`/`), `Projects` (`#projects`), `About` (`#about`) — Projects and About are anchor
placeholders on the home page. React Router is active.

---

## R Workflow & Widgets

R scripts in `projects/` generate interactive HTML widgets (via `ggiraph` + `htmlwidgets`)
saved to `public/widgets/`. These are embedded in project detail pages via `<iframe>`.

### Running R manually
The rWatchPlugin was removed from `vite.config.js` (it slowed down the dev server).
Run R scripts manually from the project root when you need to regenerate a widget:

```bash
"C:/Program Files/R/R-4.4.2/bin/Rscript.exe" "projects/mortgage-rates-beeswarm/beeswarm.R"
```

### saveWidget() quirk
`htmlwidgets::saveWidget()` outside of knitr/Quarto prepends a YAML metadata block before
the actual `<!DOCTYPE html>` document. The R scripts include a post-processing step at
the end that strips everything before the `<!DOCTYPE html>` line:

```r
raw   <- readLines(out_path, warn = FALSE)
start <- which(startsWith(trimws(raw), "<!DOCTYPE html"))[1]
writeLines(raw[start:length(raw)], out_path)
```

This must be included in every R script that calls `saveWidget()`.

### Chart logo (`public/chart-logo.svg`)
A separate logo file for embedding in R charts. Key differences from `logo.svg`:
- Dark background (`#2A3531`) **baked into the SVG** — no `image_background()` needed
- Same 7-stripe palette as navbar logo: `#CD2922 → #EC6C20 → #F6A723 → #FAC030 → #13A29C → #0C7C7D → #2A3531`
- `viewBox="0 -10 560 235"` — 10px padding above cap, 15px below baseline (prevents G clipping)
- `stroke-width="14"` matching navbar logo
- Rasterize at `width = 4000` via `image_read_svg()` for sharpness

### Footer strip in R charts
Charts use a dark `#2A3531` footer strip placed via `annotation_custom` with `coord_cartesian(clip = "off")`.
Key parameters (tuned for `width_svg=11, height_svg=8`, `plot.margin` bottom=1.2cm):

| Variable     | Value        | Purpose                                              |
|--------------|--------------|------------------------------------------------------|
| `footer_y`   | `-0.155`     | Rect center — ensures coverage past canvas bottom    |
| `footer h`   | `0.12 npc`   | Generous height — canvas clips the excess            |
| `content_y`  | `-0.130`     | Logo + caption center — within visible band          |
| Logo width   | `0.07 npc`   | —                                                    |
| Logo height  | `0.07 * 235/560 * 1.4 npc` | Taller than natural ratio; same width |

- Source credit ("Source: Freddie Mac") is a `textGrob` left-aligned in the footer (`#C8BAA0`, 13pt)
- Logo is a `rasterGrob` right-aligned in the footer

### Axis margins (beeswarm theme)
```r
axis.title.x.bottom = element_text(margin = margin(t = 8)),
axis.title.x.top    = element_text(margin = margin(b = 8)),
axis.text.x.top     = element_text(margin = margin(b = 8))
```

### Claude's R workflow
**Always run the R script immediately after editing it** — do not wait for the user to ask.

---

## Deployment

- **Live site:** genarovilla.com
- **DNS / CDN:** Cloudflare (proxies traffic to Vercel)
- **Host:** Vercel (connected to GitHub repo `gvill91/gv-portfolio-site`)
- **Deploy trigger:** push to `master` → Vercel auto-builds (`npm run build`) → Cloudflare serves updated site
- **vercel.json** rewrites all routes to `/index.html` (required for React Router client-side routing)

There is no manual deploy step — every `git push origin master` publishes to genarovilla.com automatically.

---

## Key Decisions & Preferences

- **No last name in UI** — refer to the owner as "Genaro" only
- **No job title in UI** — the hero intro describes the site's purpose, not his employer
- **No external libraries** — keep it plain React + CSS unless explicitly needed
- **Light theme** — warm sandy background (#F5ECD7) chosen for uplifting feel and to
  complement lighter chart/visualization backgrounds. A dark theme was explored and reverted.
- **Card thumbnails** — use `thumb: '/filename.png'` in the PROJECTS array; if omitted,
  card falls back to a `thumbBg` colored div placeholder
- **Profile photo** — drop file at `public/profile.jpg` to populate the hero image slot
