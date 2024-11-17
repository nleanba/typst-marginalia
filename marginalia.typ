#let marginalia = (
  left: (
    far: 16mm,
    width: 20mm,
    sep: 5mm,
  ),
  right: (
    far: 16mm,
    width: 50mm,
    sep: 8mm,
  ),
  book: true
)

#let marginalia_margin(..rest) = {
  if marginalia.book {
    (
      inside: marginalia.left.far + marginalia.left.width + marginalia.left.sep,
      outside: marginalia.right.far + marginalia.right.width + marginalia.right.sep,
      ..rest.named()
    )
  } else {
    (
      left: marginalia.left.far + marginalia.left.width + marginalia.left.sep,
      right: marginalia.right.far + marginalia.right.width + marginalia.right.sep,
      ..rest.named()
    )
  }
}

#set page(
  paper: "a4",
  margin: marginalia_margin(y: 2cm)
)

#let wideblock(reverse: false, double: false, it) = context {
  if double and reverse {
    panic("Cannot be both reverse and double wide.")
  }
  
  let left = if not(marginalia.book) or calc.odd(here().page()) {
    if double or reverse {
      marginalia.left.width + marginalia.left.sep
    } else { 0% }
  } else {
    if reverse { 0% } else {
      marginalia.right.width + marginalia.right.sep
    }
  }

  let right = if not(marginalia.book) or calc.odd(here().page()) {
    if reverse { 0% } else {
      marginalia.right.width + marginalia.right.sep
    }
  } else {
    if double or reverse {
      marginalia.left.width + marginalia.left.sep
    } else { 0% }
  }

  pad(
    left: -left, right: -right, it
  )
}

// absolute sides
#let _note_descents = state("_note_descents", (page: -1, left: 0pt, right: 0pt))
#let _get_note_descents_left(_note_descents_dict, page) = {
  return if _note_descents_dict.page < page { 0pt } else { _note_descents_dict.left }
}
#let _set_note_descents_left(y, page) = context {
  _note_descents.update(old => (page: page, left: y, right: old.right))
}
#let _get_note_descents_right(_note_descents_dict, page) = {
  return if _note_descents_dict.page < page { 0pt } else { _note_descents_dict.right }
}
#let _set_note_descents_right(y, page) = context {
  _note_descents.update(old => (page: page, left: old.left, right: y))
}

// absolute left
#let _note_left(dy: 0pt, body) = context {
  let anchor = here().position()
  let page = here().page()
  let prev_descent = _get_note_descents_left(_note_descents.get(), page);
  let lineheight = measure(v(par.leading)).height
  let vadjust = if prev_descent > anchor.y - lineheight { prev_descent - anchor.y } else { -lineheight }
  let offset = if not(marginalia.book) or calc.odd(page) {
    marginalia.left.far - anchor.x
  } else {
    marginalia.right.far - anchor.x
  }
  let width = if not(marginalia.book) or calc.odd(page) {
    marginalia.left.width
  } else {
    marginalia.right.width
  }
  let notebox = box(width: marginalia.left.width, body)
  box(
    place(
      dx: offset,
      dy: vadjust + dy,
      notebox
    )
  )
  // 6pt spacing between notes 
  _set_note_descents_left(anchor.y + vadjust + measure(notebox).height + 6pt, page)
}

// absolute right
#let _note_right(dy: 0pt, body) = context {
  let anchor = here().position()
  let pagewidth = page.width
  let page = here().page()
  let prev_descent = _get_note_descents_right(_note_descents.get(), page);
  let lineheight = measure(v(par.leading)).height
  let vadjust = if prev_descent > anchor.y - lineheight { prev_descent - anchor.y } else { -lineheight }
  let offset = if not(marginalia.book) or calc.odd(page) {
    pagewidth - anchor.x - marginalia.right.far - marginalia.right.width
    // marginalia.left.far
  } else {
    marginalia.right.far
  }
  let width = if not(marginalia.book) or calc.odd(page) {
    marginalia.left.width
  } else {
    marginalia.right.width
  }
  let notebox = box(width: marginalia.right.width, body)
  box(
    place(
      dx: offset,
      dy: vadjust + dy,
      notebox
    )
  )
  // 6pt spacing between notes
  _set_note_descents_right(anchor.y + vadjust + measure(notebox).height + 6pt, page)
}

#let note(reverse: false, dy: 0pt, body) = context {
  set text(size: 9pt)
  if reverse or (marginalia.book and calc.even(here().page())) {
    _note_left(dy: dy, body)
  } else {
    _note_right(dy: dy, body)
  }
}


/***************************/
// not relevant for package
#set par(justify: true)

// Visualize
#set page(
  header: rect(width: 100%, height: 100%, fill: aqua, inset: 0pt)[Header],
  footer: rect(width: 100%, height: 100%, fill: aqua, inset: 0pt)[Footer],

  background: context if not(marginalia.book) or calc.odd(here().page()) {
    place(
      dx: marginalia.left.far,
      rect(width: marginalia.left.width, stroke: (x: luma(90%)), height: 100%)
    )
    place(
      dx: marginalia.left.far + marginalia.left.width + marginalia.left.sep,
      rect(width: 10pt, stroke: (left: luma(90%)), height: 100%)
    )
    place(
      right,
      dx: -marginalia.right.far,
      rect(width: marginalia.right.width, stroke: (x: luma(90%), y: none), height: 100%)
    )
    place(
      right,
      dx: -marginalia.right.far - marginalia.right.width - marginalia.right.sep,
      rect(width: 10pt, stroke: (right: luma(90%)), height: 100%)
    )
  } else {
    place(
      dx: marginalia.right.far,
      rect(width: marginalia.right.width, stroke: (x: luma(90%)), height: 100%)
    )
    place(
      dx: marginalia.right.far + marginalia.right.width + marginalia.right.sep,
      rect(width: 10pt, stroke: (left: luma(90%)), height: 100%)
    )
    place(
      right,
      dx: -marginalia.left.far,
      rect(width: marginalia.left.width, stroke: (x: luma(90%), y: none), height: 100%)
    )
    place(
      right,
      dx: -marginalia.left.far - marginalia.left.width - marginalia.left.sep,
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
== Wide Blocks

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

== Margin-Notes
Hello <n1>
foo#_note_left[Note 1]
blah <n2>
blah.#_note_left[Note 2]
Duh, <n3>
Blah.#_note_left[Note 3]
Duh, <n4>
Hello#_note_right[Note 1]
blah <n5>
blah blah.#_note_right[Note 2]
Fin? <n6>
blah blah.#_note_right[Note 3]
Fin. <n7>

#context _note_descents.at(<n1>) \
#context _note_descents.at(<n2>) \
#context _note_descents.at(<n3>) \
#context _note_descents.at(<n4>) \
#context _note_descents.at(<n5>) \
#context _note_descents.at(<n6>) \
#context _note_descents.at(<n7>) \
#context _note_descents.final()

---

By default, the ```typst #note[...]``` command places a note to the right/outer margin, like so:#note[This is a note.] \
By giving the argument ```typc reverse: true```, we obtain a note on the left/inner margin.#note(reverse: true)[Reversed.]


#pagebreak(to: "even", weak: true)
= Even Page
== Wide Blocks

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


// == Visualized
// #rect(width: 100%, height: 1fr, fill: aqua, inset: 0pt)[  
//   #context page.margin \
//   Odd page: #context calc.odd(here().page())
// ]
// #rect(width: 100%, height: 100%, fill: aqua, inset: 0pt)[
//   Page 2 \
//   #context page.margin \
//   Odd page: #context calc.odd(here().page())
// ]
