# Typst Label Maker

A flexible Typst script for generating printable labels (e.g., box spines or thin shelf labels) from a CSV file, with automatic layout, orientation, and font scaling based on label dimensions.

---

## Features

* **CSV-driven**: Define all labels in a simple `labels.csv` file.
* **Automatic orientation**:
  * Tall labels rotate vertically (ideal for box spines).
  * Wide labels render horizontally (ideal for thin shelf labels).
* **Dynamic font sizing**: Text scales proportionally to label height for consistent readability.
* **Adaptive title spacing**: Author and title widths adjust based on text length.
* **Print-ready**: US Letter page size with configurable margins and gutters.

---

## Requirements

* [Typst](https://typst.app/) (local CLI or web editor)
* A CSV file named `labels.csv`
* The `Linux Libertine` font (or change the font in the script)

---

## CSV Format

Your `labels.csv` file should have the following columns:

```
author,title,height,width,adjustment
```

* **author**: Main label text (e.g., author, category, or collection name)
* **title**: Secondary text (rendered in uppercase)
* **height**: Label height in inches
* **width**: Label width in inches
* **adjustment**: Add/Sub font size without changing other dimensions 

### Example

```
author,title,height,width,adjustment
C. S. Lewis,Mere Christianity,9,2,
Aristotle,Metaphysics,1,4, +2
```

---

## How It Works

### Orientation Logic

* If `height ≥ width`, the label is treated as a **vertical box label** and rotated 90°.
* Otherwise, it is rendered as a **horizontal thin label**.

### Font Scaling

* Vertical labels: font size ≈ **8% of total height**
* Horizontal labels: font size ≈ **30% of total height**

This keeps text visually balanced across very different label sizes.

### Layout Details

* Author appears above a divider line.
* Title is rendered in uppercase for visual hierarchy.
* Insets ensure safe margins for cutting and printing.

---

## Customization

You can easily tweak:

* **Margins & page size**

  ```typst
  #set page(paper: "us-letter", margin: 0.5in)
  ```

* **Font and typography**

  ```typst
  set text(font: "Linux Libertine", size: f-size)
  ```

* **Spacing & rules**

  * Divider line length
  * Insets
  * Grid row/column proportions

* **Title width behavior**

  * Adjust bounds in `title-width-factor` to change how aggressively long titles expand.

---

## Output

The script renders all labels in a single-column grid with consistent vertical spacing, ready to print, cut, and apply.
