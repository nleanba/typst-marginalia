#let marginalia = (
  left: (
    far: 16mm,
    marginalia: 20mm,
    sep: 5mm,
  ),
  right: (
    far: 16mm,
    marginalia: 50mm,
    sep: 8mm,
  ),
  book: true
)

#let marginalia_margin = (..rest) => {
  if marginalia.book {
    (
      inside: marginalia.left.far + marginalia.left.marginalia + marginalia.left.sep,
      outside: marginalia.right.far + marginalia.right.marginalia + marginalia.right.sep,
      ..rest.named()
    )
  } else {
    (
      left: marginalia.left.far + marginalia.left.marginalia + marginalia.left.sep,
      right: marginalia.right.far + marginalia.right.marginalia + marginalia.right.sep,
      ..rest.named()
    )
  }
}

#set page(
  paper: "a4",
  margin: marginalia_margin(y: 2cm)
)

#let wideblock = (reverse: false, double: false, it) => context {
  if double and reverse {
    panic("Cannot be both reverse and double wide.")
  }
  
  let left = if not(marginalia.book) or calc.odd(here().page()) {
    if double or reverse {
      marginalia.left.marginalia + marginalia.left.sep
    } else { 0% }
  } else {
    if reverse { 0% } else {
      marginalia.right.marginalia + marginalia.right.sep
    }
  }

  let right = if not(marginalia.book) or calc.odd(here().page()) {
    if reverse { 0% } else {
      marginalia.right.marginalia + marginalia.right.sep
    }
  } else {
    if double or reverse {
      marginalia.left.marginalia + marginalia.left.sep
    } else { 0% }
  }

  pad(
    left: -left, right: -right, it
  )
}

// not relevant for package
#set par(justify: true)

// Visualize
#set page(
  header: rect(width: 100%, height: 100%, fill: aqua, inset: 0pt)[Header],
  footer: rect(width: 100%, height: 100%, fill: aqua, inset: 0pt)[Footer],

  background: context if not(marginalia.book) or calc.odd(here().page()) {
    place(
      dx: marginalia.left.far,
      rect(width: marginalia.left.marginalia, stroke: (x: luma(90%)), height: 100%)
    )
    place(
      dx: marginalia.left.far + marginalia.left.marginalia + marginalia.left.sep,
      rect(width: 10pt, stroke: (left: luma(90%)), height: 100%)
    )
    place(
      right,
      dx: -marginalia.right.far,
      rect(width: marginalia.right.marginalia, stroke: (x: luma(90%), y: none), height: 100%)
    )
    place(
      right,
      dx: -marginalia.right.far - marginalia.right.marginalia - marginalia.right.sep,
      rect(width: 10pt, stroke: (right: luma(90%)), height: 100%)
    )
  } else {
    place(
      dx: marginalia.right.far,
      rect(width: marginalia.right.marginalia, stroke: (x: luma(90%)), height: 100%)
    )
    place(
      dx: marginalia.right.far + marginalia.right.marginalia + marginalia.right.sep,
      rect(width: 10pt, stroke: (left: luma(90%)), height: 100%)
    )
    place(
      right,
      dx: -marginalia.left.far,
      rect(width: marginalia.left.marginalia, stroke: (x: luma(90%), y: none), height: 100%)
    )
    place(
      right,
      dx: -marginalia.left.far - marginalia.left.marginalia - marginalia.left.sep,
      rect(width: 10pt, stroke: (right: luma(90%)), height: 100%)
    )
  }
)

#block(text(size: 3em, weight: "black")[Marginalia])
_Write into the margins!_

#outline(indent: 2em)

= Setup
TODO

// #context if calc.even(here().page()) {pagebreak(to: "odd", weak: true)}
= Odd Page
(or all pages ```typst #if book = false```)
== Wide blocks

Note that setting both `reverse: true` and `double: true` will panic.

#wideblock[
  ```typst #wideblock[...]```:
  #lorem(23)
]

#wideblock(reverse: true)[
  ```typst #wideblock(reverse: true)[...]```:
  #lorem(16)
]

#wideblock(double: true)[
  ```typst #wideblock(double: true)[...]```:
  #lorem(26)
]

#pagebreak(to: "even", weak: true)
= Even Page
== Wide blocks

#wideblock[
  ```typst #wideblock[...]```
  #lorem(20)
]

#wideblock(reverse: true)[
  ```typst #wideblock(reverse: true)[...]```:
  #lorem(17)
]

#wideblock(double: true)[
  ```typst #wideblock(double: true)[...]```:
  #lorem(24)
]
