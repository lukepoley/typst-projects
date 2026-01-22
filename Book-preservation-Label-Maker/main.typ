
Gmct
label_app
main.typ
Files

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
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
)
