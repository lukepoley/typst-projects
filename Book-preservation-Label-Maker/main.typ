#set page(paper: "us-letter", margin: 0.5in)

// --- Dynamic Scaling Calculation ---
#let get-font-size(h, w, is-vertical) = {
  let h = float(h)
  let w = float(w)
  if is-vertical {
    return (h * 0.05 + w * 0.04) * 1in
  } else {
    return (h * 0.1 + w * 0.026) * 1in
  }
}

// --- Helper: Split text at the middle-most space ---
#let balance-text(txt, threshold: 20) = {
  let txt = str(txt).trim()
  let chars = str.len(txt)
  if chars < threshold or chars == 0 { return txt }
  
  let words = txt.split(" ")
  if words.len() <= 1 { return txt } 
  
  let mid = chars / 2
  let best-space-index = 0
  let min-diff = chars
  let current-pos = 0
  
  for i in range(words.len() - 1) {
    current-pos += words.at(i).len()
    let diff = calc.abs(mid - current-pos)
    if diff < min-diff {
      min-diff = diff
      best-space-index = i
    }
    current-pos += 1 
  }
  
  return words.slice(0, best-space-index + 1).join(" ") + "\n" + words.slice(best-space-index + 1).join(" ")
}

#let clamp(x, min, max) = {
  if x < min { min }
  else if x > max { max }
  else { x }
}

#let title-width-factor(title) = {
  let len = str.len(str(title))
  let t = clamp((len - 5) / (40 - 5), 0, 1)
  0.2 + t * 2
}

#let make-label(author, title, h-val, w-val, font-adj) = {
  // 1. Clean H/W (handles spaces and non-string types)
  let clean-h = float(str(h-val).trim())
  let clean-w = float(str(w-val).trim())
  
  // 2. Clean Font Adj (handles missing column, blank column, or spaces)
  let adj-str = str(font-adj).trim()
  let clean-adj = if adj-str == "" { 0.0 } else { float(adj-str) }
  
  let box-h = clean-h * 1in
  let box-w = clean-w * 1in
  let use-line = clean-h >= clean-w
  
  let base-f-size = get-font-size(clean-h, clean-w, use-line)
  let final-f-size = base-f-size + (clean-adj * 1pt)
  
  let threshold = if use-line { 15 } else { 25 }
  let has-author = str(author).trim() != ""
  let balanced-author = if has-author { balance-text(author, threshold: threshold) } else { "" }
  let balanced-title = balance-text(upper(title), threshold: threshold)

  let content = {
    set text(font: "Linux Libertine", size: final-f-size, hyphenate: false)
    set par(leading: 0.4em, justify: false)
    set align(center + horizon)

    if not has-author {
      // IF AUTHOR IS BLANK: Center the title only
      block(width: 90%, balanced-title)
    } else if use-line {
      grid(
        columns: 100%,
        rows: (1fr, auto, 1fr, auto, 1fr),
        align: center + horizon,
        [],
        block(width: 95%, balanced-author),
        line(length: box-h * 0.2, stroke: 0.5pt),
        block(width: 95%, balanced-title),
        []
      )
    } else {
      grid(
        columns: (1fr, auto, 1fr, auto, 1fr),
        align: center + horizon,
        [],
        block(width: box-w * title-width-factor(author), balanced-author),
        [],
        block(width: box-w * title-width-factor(title), balanced-title),
        []
      )
    }
  }

  if use-line {
    rotate(-90deg, reflow: true, figure(
      rect(width: box-w, height: box-h, stroke: 0.5pt, inset: (x: 0.1in, y: 0.1in), content)
    ))
  } else {
    rect(width: box-w, height: box-h, stroke: 0.5pt, inset: (x: 0.1in, y: 0.05in), content)
  }
}

// --- Render Logic ---
#let data = csv("labels.csv")

#grid(
  columns: 1,
  gutter: 0.4in,
  // Processes every line (no headers skipped)
  ..data.map(row => {
    let author = row.at(0, default: "")
    let title  = row.at(1, default: "Untitled")
    let h      = row.at(2, default: "2")
    let w      = row.at(3, default: "2")
    
    // DELIMITER LOGIC:
    // If the row ends after the 4th column (no trailing comma), row.len() is 4.
    // row.at(4, default: "0") handles both the missing column and the blank column.
    let font-adj = row.at(4, default: "0")
    
    make-label(author, title, h, w, font-adj)
  })
)
