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
  book: true,
  flush_numbers: false,
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

#let notecounter = counter("notecounter")
// #let _notenumbering = ("●","○","◆","◇","■","□","▲","△")
#let _notenumbering = ("◆","●","■","▲","◇","○","□","△")
#let as-note = (.., last) => {
  let symbol = if last >= _notenumbering.len() or last <= 0 { [ #(_notenumbering.len() - last + 1) ] } else { _notenumbering.at(last - 1) }
  return text(weight: 900, font: "Inter", size: 6pt, style: "normal", fill: rgb(54%, 72%, 95%), symbol)
}


// absolute sides
#let _note_descents = state("_note_descents", ( "1": (left: 0pt, right: 0pt)))
#let _get_note_descents_left(_note_descents_dict, page) = {
  _note_descents_dict.at(str(page), default: (left: 0pt, right: 0pt)).left
}
#let _set_note_descents_left(y, page) = context {
  _note_descents.update(old => {
    let new = old.at(str(page), default: (left: 0pt, right: 0pt))
    new.insert("left", y)
    old.insert(str(page), new)
    old
  })
}
#let _get_note_descents_right(_note_descents_dict, page) = {
  _note_descents_dict.at(str(page), default: (left: 0pt, right: 0pt)).right
}
#let _set_note_descents_right(y, page) = context {
  _note_descents.update(old => {
    let new = old.at(str(page), default: (left: 0pt, right: 0pt))
    new.insert("right", y)
    old.insert(str(page), new)
    old
  })
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
  let new_descent = anchor.y + vadjust + measure(notebox).height;
  // 6pt spacing between notes
  context _set_note_descents_left(new_descent + 6pt, here().page())
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
  } else {
    pagewidth - anchor.x - marginalia.left.far - marginalia.left.width
  }
  let width = if not(marginalia.book) or calc.odd(page) {
    marginalia.left.width
  } else {
    marginalia.right.width
  }
  let notebox = box(width: marginalia.right.width, body)
  box(
    width: 0pt,
    place(
      dx: offset,
      dy: vadjust + dy,
      notebox
    )
  )
  // 6pt spacing between notes
  context _set_note_descents_right(anchor.y + vadjust + measure(notebox).height + 6pt, page)
}

#let note(numbered: true, reverse: false, dy: 0pt, body) = {
  set text(size: 9pt, style: "italic", weight: "regular")
  if numbered {
    notecounter.step()
    let body = context if marginalia.flush_numbers {
      notecounter.display(as-note)
      h(1.5pt)
      body
    } else {
      box(width: 0pt, {
        h(-1.5pt - measure(notecounter.display(as-note)).width)
        notecounter.display(as-note)
      })
      body
    }
    h(0pt, weak: true)
    box(context {
      h(1.5pt, weak: true)
      notecounter.display(as-note)
      if marginalia.book and calc.even(here().page()) {
        if reverse {
          _note_right(dy: dy, body)
        } else {
          _note_left(dy: dy, body)
        }
      } else {
        if reverse {
          _note_left(dy: dy, body)
        } else {
          _note_right(dy: dy, body)
        }
      }
    })
  } else {
    box(context {
      if reverse or (marginalia.book and calc.even(here().page())) {
        _note_left(dy: dy, body)
      } else {
        _note_right(dy: dy, body)
      }
    })
  }
}



#let wideblock(reverse: false, double: false, it) = context {
  if double and reverse {
    panic("Cannot be both reverse and double wide.")
  }
  
  let left = if not(marginalia.book) or calc.odd(here().page()) {
    if double or reverse {
      marginalia.left.width + marginalia.left.sep
    } else { 0pt }
  } else {
    if reverse { 0pt } else {
      marginalia.right.width + marginalia.right.sep
    }
  }

  let right = if not(marginalia.book) or calc.odd(here().page()) {
    if reverse { 0pt } else {
      marginalia.right.width + marginalia.right.sep
    }
  } else {
    if double or reverse {
      marginalia.left.width + marginalia.left.sep
    } else { 0pt }
  }

  pad(left: -left, right: -right, it)

  // / Does not work:
  // context {
  //   let y = here().position().y
  //   let padded = pad(
  //     left: -left, right: -right, it
  //   )
  //   padded
  //   let plus = measure(padded).height
  //   if left > 0pt {
  //     _set_note_descents_left(y + plus + 6pt, here().page())
  //   }
  //   if right > 0pt {
  //     _set_note_descents_right(y + plus + 6pt, here().page())
  //   }
  // }
}


#set page(
  paper: "a4",
  margin: marginalia_margin(),
  header: context if here().page() > 1 {
    if not(marginalia.book) or calc.odd(here().page()) {
      notecounter.update(0)
      wideblock(double: true, {
        box(width: marginalia.left.width)[
          Page
          #counter(page).display( "1 of 1", both: true)
        ]
        h(marginalia.left.sep)
        box(width: 1fr, smallcaps[Marginalia])
        h(marginalia.right.sep)
        box(width: marginalia.right.width, fill: yellow)[
          #datetime.today().display("[day]. [month repr:long] [year]")
        ]
      })
    } else {
      notecounter.update(0)
      wideblock(double: true, {
        box(width: marginalia.right.width)[
          #datetime.today().display("[day]. [month repr:long] [year]")
        ]
        h(marginalia.right.sep)
        box(width: 1fr, smallcaps[Marginalia])
        h(marginalia.left.sep)
        box(width: marginalia.left.width)[
          Page
          #counter(page).display( "1 of 1", both: true)
        ]
      })
    }
  }
)

/***************************/
// not relevant for package
#set par(justify: true)

// Visualize
#set page(
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

== Margin-Notes
By default, the ```typst #note[...]``` command places a note to the right/outer margin, like so:#note[This is a note.].
By giving the argument ```typc reverse: true```, we obtain a note on the left/inner margin.#note(reverse: true)[Reversed.]
If~#note[Note 1] we~#note[Note 2] place/*~#note[Note 3]*/ multiple/*~#note[Note 4]*/ notes/*~#note[Note 5]*/ in one line, they automatically adjust their positions (Up to a limit of apparently up to three. I am not sure why exactly this is, as the shifts should not have cyclical dependencies but it should be able to calculate them in-order).
However, a ```typc dy``` argument can be passed to shift them by that length vertically.

The margin notes are decorated with little symbols, which by default hang into the gap. If this is not desired, set the configuration option ```typc flush_numbers: true```.
Setting the argument ```typc numbered: false```, we obtain notes without icon/number.#note(numbered: false)[Like this.]

It is recommended to reset the `notecounter` for every page in the header. TODO how?


== Wide Blocks

Note that setting both `reverse: true` and `double: true` will panic.

#wideblock[
  ```typst #wideblock[...]```:
  Whilst a bit hacky, it is possible to use notes in wide blocks:#note(reverse: true)[Voila], but make sure to set the ```typc reverse``` argument appropriately.#note[Or ensure that the notes don't overlap the wide block some other way.]
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


== Margin-Notes
Margin notes adjust themselves to even pages.#note[Ta-dah!]
Here, to get to the right margin, now the inner margin, we use reversed notes.#note(reverse: true)[Comme ça.]


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
