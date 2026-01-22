#set page(paper: "us-letter", margin: 0.5in)

// --- Dynamic Scaling Calculation ---
#let get-font-size(h, is-vertical) = {
  if is-vertical {
    // Vertical boxes: font is roughly 8% of total height
    return float(h) * 1in * 0.08
  } else {
    // Thin horizontal boxes: font is roughly 30% of height
    return float(h) * 1in * 0.30
  }
}

// Helper
#let clamp(x, min, max) = {
  if x < min { min }
  else if x > max { max }
  else { x }
}

// --- Logic for Title Space ---
#let title-width-factor(title) = {
  let len = str.len(title)

  // Tune these bounds as desired
  let min-len = 5     // very short title
  let max-len = 40    // very long title

  // Normalize length to 0–1
  let t = clamp(
    (len - min-len) / (max-len - min-len),
    0,
    1
  )

  // Map to 0.2–1.0 range
  0.2 + t * 0.8
}

#let make-label(author, title, h-val, w-val) = {

  let box-h = float(h-val) * 1in
  let box-w = float(w-val) * 1in
  let use-line = float(h-val) >= float(w-val)
  let f-size = get-font-size(h-val, use-line)

  if use-line {

    // ============================
    // Box Label Logic
    // ============================
    rotate(-90deg, reflow: true, figure(
      rect(
        width: box-w,
        height: box-h,
        stroke: 0.5pt,
        inset: (x: 0.2in, y: 0.1in),

        {
          set text(font: "Linux Libertine", size: f-size, hyphenate: false)
          set par(leading: 0.3em, justify: false)

          grid(
            columns: 100%,
            rows: (1fr, auto, 1fr, auto, 1fr),
            align: center + horizon,

            [],
            block(width: 90%, author),
            line(length: box-h * 0.2, stroke: 0.5pt),
            block(width: 90%, upper(title)),
            []
          )
        }
      )
    ))

  } else {

    // ============================
    // Thin Label Logic
    // ============================
    rect(
      width: box-w,
      height: box-h,
      stroke: 0.5pt,
      inset: (x: 0.2in, y: 0.1in),

      {
        set text(font: "Linux Libertine", size: f-size, hyphenate: false)
        set par(leading: 0.3em, justify: false)

        align(horizon, grid(
          columns: (1fr, auto, 1fr, auto, 1fr),
          align: horizon,

          [],
          block(width: box-w * title-width-factor(author), author),
          [],
          block(width: box-w * title-width-factor(title), upper(title)),
          []
        ))
      }
    )

  }
}

// --- Render ---
#let data = csv("labels.csv")

#grid(
  columns: 1,
  gutter: 0.4in,
  ..data.slice(1).map(row => {
    let (author, title, h, w) = row
    make-label(author, title, h, w,)
  })
)
