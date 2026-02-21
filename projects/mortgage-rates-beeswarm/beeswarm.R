library(tidyverse)
library(ggbeeswarm)
library(ggiraph)
library(showtext)
library(htmlwidgets)
library(scales)
library(magick)
library(grid)

# ── Fonts ─────────────────────────────────────────────────────────────────────
font_add_google("Wix Madefor Text", "WixMadeforText")
showtext_auto()
showtext_opts(dpi = 300)

# ── GV brand colors ───────────────────────────────────────────────────────────
gv_bg    <- "#F5ECD7"
gv_dark  <- "#2A3531"
gv_muted <- "#7A6E5D"
gv_low   <- "#13A29C"   # teal  → low rates
gv_mid   <- "#F6A723"   # amber → mid rates
gv_high  <- "#CD2922"   # red   → high rates

# ── Data ──────────────────────────────────────────────────────────────────────
df <- read_csv("https://www.freddiemac.com/pmms/docs/PMMS_history.csv")

floor_decade <- function(value) { return(value - value %% 10) }

df2 <- df %>%
  mutate(date = as.Date(date, format = "%m/%d/%Y")) %>%
  select(date, pmms30) %>%
  filter(year(date) > 1989) %>%
  mutate(
    decade = paste0(floor_decade(year(date)), "s"),
    year   = year(date)
  )

df2_minmax <- df2 %>%
  group_by(year) %>%
  summarize(
    min_pmms30 = min(pmms30, na.rm = TRUE),
    max_pmms30 = max(pmms30, na.rm = TRUE)
  ) %>%
  ungroup()

latest_date   <- max(df2$date)
latest_pmms30 <- df2 %>% filter(date == latest_date)

# ── Theme ─────────────────────────────────────────────────────────────────────
theme_gv <- function(font = "WixMadeforText", bs = 12, ...) {
  theme_minimal(base_size = bs, base_family = font, ...) +
    theme(
      axis.text        = element_text(color = gv_muted),
      axis.title       = element_text(color = gv_muted),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_blank(),
      plot.margin      = margin(0.5, 0.5, 1.2, 0.5, "cm"),
      plot.background  = element_rect(fill = gv_bg, color = NA),
      panel.background = element_rect(fill = gv_bg, color = NA),
      plot.title       = element_text(
        size   = rel(1.5),
        face   = "bold",
        hjust  = 0,
        color  = gv_dark,
        margin = margin(0, 0, 7, 0)
      ),
      plot.subtitle = element_text(face = "italic", hjust = 0, color = gv_muted),
      plot.caption  = element_text(hjust = 0, color = "#C8BAA0"),
      legend.text   = element_text(color = gv_muted),
      axis.title.x.bottom = element_text(margin = margin(t = 8)),
      axis.title.x.top    = element_text(margin = margin(b = 8)),
      axis.text.x.top     = element_text(margin = margin(b = 8))
    )
}

# ── Plot ──────────────────────────────────────────────────────────────────────
set.seed(20250625)

p <- ggplot(
  data = df2 %>% filter(year > 2014, date != latest_date),
  aes(x = pmms30, y = fct_rev(factor(year)))
) +
  # Min/max range band
  geom_rect(
    data = df2_minmax %>% filter(year > 2014),
    aes(
      xmin = min_pmms30, xmax = max_pmms30,
      ymin = as.numeric(fct_rev(factor(year))) - 0.4,
      ymax = as.numeric(fct_rev(factor(year))) + 0.4
    ),
    inherit.aes = FALSE,
    fill  = gv_dark,
    alpha = 0.08,
    color = NA
  ) +
  # Interactive beeswarm dots
  geom_point_interactive(
    aes(
      fill    = pmms30,
      color   = pmms30,
      tooltip = paste0(
        "<b>", format(date, "%b %d, %Y"), "</b><br>",
        "Rate: ", pmms30, "%"
      ),
      data_id = as.character(date)
    ),
    position    = position_quasirandom(method = "quasirandom"),
    shape       = 21,
    size        = 2.5,
    alpha       = 0.75,
    show.legend = FALSE
  ) +
  # Latest point — outer ring
  geom_point_interactive(
    data = latest_pmms30,
    aes(
      x       = pmms30,
      y       = fct_rev(factor(year)),
      tooltip = paste0("<b>Latest</b><br>", format(latest_date, "%b %d, %Y"), "<br>Rate: ", pmms30, "%"),
      data_id = "latest"
    ),
    inherit.aes = FALSE,
    shape       = 21,
    color       = gv_dark,
    fill        = "white",
    size        = 4.5,
    show.legend = FALSE
  ) +
  # Latest point — filled
  geom_point_interactive(
    data = latest_pmms30,
    aes(
      x       = pmms30,
      y       = fct_rev(factor(year)),
      fill    = pmms30,
      tooltip = paste0("<b>Latest</b><br>", format(latest_date, "%b %d, %Y"), "<br>Rate: ", pmms30, "%"),
      data_id = "latest"
    ),
    inherit.aes = FALSE,
    shape       = 21,
    color       = gv_dark,
    size        = 3,
    show.legend = FALSE
  ) +
  # Latest annotation text
  annotate(
    "text",
    x      = latest_pmms30$pmms30 - 0.8,
    y      = as.numeric(fct_rev(factor(latest_pmms30$year))) + 0.15,
    label  = paste0("Latest: ", percent(latest_pmms30$pmms30, scale = 1, accuracy = 0.01)),
    hjust  = 0,
    vjust  = 1,
    color  = gv_dark,
    size   = 13/.pt,
    family = "WixMadeforText"
  ) +
  # Latest annotation arrow
  geom_curve(
    aes(
      x    = latest_pmms30$pmms30 - 0.35,
      y    = as.numeric(fct_rev(factor(latest_pmms30$year))) + 0.2,
      xend = latest_pmms30$pmms30,
      yend = as.numeric(fct_rev(factor(latest_pmms30$year)))
    ),
    curvature = -0.4,
    color     = gv_dark,
    linewidth = 0.4
  ) +
  scale_x_continuous(labels = scales::percent_format(scale = 1),
                     breaks = seq(1,10,by=0.5),
                     sec.axis = dup_axis()
) +
  scale_color_gradientn(colors = c(gv_low, gv_mid, gv_high)) +
  scale_fill_gradientn(colors  = c(gv_low, gv_mid, gv_high)) +
  theme_gv(bs = 13) +
  labs(
    y     = "Year",
    x     = "30-Year Fixed Mortgage Rate (%)",
    title = "Mortgage Rate Dispersion by Year",
    subtitle = "Weekly 30-Year Mortgage Rate Average",
    caption = NULL  # source credit added as a grob in the footer strip
  ) +
  coord_cartesian(clip = "off")

# ── Logo & footer ─────────────────────────────────────────────────────────────
# chart-logo.svg: viewBox "0 -10 560 235" → 10px padding above cap, 15px below baseline.
# Dark background baked in; 7-stripe palette matching navbar logo.svg.
# stroke-width=14 matching navbar. Rendered height scaled 1.4× natural ratio to fill strip.

# Footer geometry:
# The plot panel ends at 0 npc. Below it: x-axis tick labels + x-axis title (~1.2cm),
# then the plot.margin (1.5cm). The footer should cover only the margin area at the
# very bottom — not the axis labels above it.
# With plot.margin=1.5cm and estimated panel height ~14cm:
#   axis bottom ≈ -0.086 npc, canvas bottom ≈ -0.193 npc
# footer_y = -0.155 → top at -0.095 (just below axis), bottom at -0.215 (past canvas edge)
footer_y <- -0.155

# Dark footer strip (navbar color) spanning the full chart width
footer_grob <- rectGrob(
  x      = unit(0.5,      "npc"),
  y      = unit(footer_y, "npc"),
  width  = unit(3,        "npc"),  # oversized to bleed into left/right margins
  height = unit(0.12,     "npc"),  # sized to cover the 1.5cm margin area
  gp     = gpar(fill = gv_dark, col = NA)
)

# Logo and caption sit slightly above the rect center so they aren't clipped at bottom
content_y <- -0.130

# Logo right-aligned in footer
logo_img  <- image_read_svg("public/chart-logo.svg", width = 4000)
logo_grob <- rasterGrob(
  as.raster(logo_img),
  x           = unit(0.99,       "npc"),
  y           = unit(content_y,  "npc"),
  width       = unit(0.07,                    "npc"),
  height      = unit(0.07 * 235/560 * 1.7,   "npc"),
  just        = c("right", "center"),
  interpolate = TRUE
)

# Source credit left-aligned in footer (cream text on dark background)
source_grob <- textGrob(
  "Source: Freddie Mac",
  x    = unit(0.01,      "npc"),
  y    = unit(content_y, "npc"),
  just = c("left", "center"),
  gp   = gpar(col = "#C8BAA0", fontsize = 13, fontfamily = "WixMadeforText")
)

p <- p +
  annotation_custom(footer_grob) +
  annotation_custom(logo_grob) +
  annotation_custom(source_grob)

# ── Interactive export ────────────────────────────────────────────────────────
chart <- girafe(
  ggobj      = p,
  width_svg  = 11,
  height_svg = 8,
  options = list(
    opts_hover(css = "opacity: 1; stroke-width: 1.5px;"),
    opts_hover_inv(css = "opacity: 0.2;"),
    opts_tooltip(
      css = paste0(
        "background-color:", gv_bg, ";",
        "color:", "white", ";",
        "font-family: 'Wix Madefor Text', sans-serif;",
        "font-size: 13px;",
        "padding: 8px 12px;",
        "border-radius: 6px;",
        "border: none;"
      ),
      use_fill = TRUE
    ),
    opts_sizing(rescale = TRUE)
  )
)

# Write update date for the project page
cat(sprintf('{"updated": "%s"}\n', format(Sys.Date(), "%B %d, %Y")),
    file = "src/data/mortgage-rates-meta.json")

# Save the widget
out_path <- "public/widgets/mortgage-rates-beeswarm.html"
saveWidget(
  chart,
  file          = out_path,
  selfcontained = TRUE,
  title         = "Mortgage Rate Dispersion — GV"
)

# saveWidget() outside knitr prepends a YAML block before the actual
# self-contained HTML document. Strip everything before <!DOCTYPE html>.
raw   <- readLines(out_path, warn = FALSE)
start <- which(startsWith(trimws(raw), "<!DOCTYPE html"))[1]
html  <- raw[start:length(raw)]

# Inject viewport meta tag so the widget scales correctly on mobile inside an iframe.
html  <- sub(
  '<meta charset="utf-8" />',
  '<meta charset="utf-8" />\n<meta name="viewport" content="width=device-width, initial-scale=1" />',
  html
)

# htmlwidgets sets browser sizing to fill:false (fixed 960px). Override to fill:true
# so the widget scales to 100% of the iframe width on all screen sizes.
html  <- gsub(
  '"browser":\\{"width":[0-9]+,"height":[0-9]+,"padding":[0-9]+,"fill":false\\}',
  '"browser":{"width":960,"height":500,"padding":40,"fill":true}',
  html
)
writeLines(html, out_path)
