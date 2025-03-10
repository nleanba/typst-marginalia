#import "lib.typ" as marginalia: note, wideblock

#let config = (
  inner: ( far: 16mm, width: 20mm, sep: 8mm ),
  outer: ( far: 16mm, width: 40mm, sep: 8mm ),
  top: 32mm + 11pt, bottom: 16mm,
  book: true,
  // clearance: 30pt,
  // flush-numbers: false,
  // numbering: "a",
)

#marginalia.configure(..config)
#set page(
  ..marginalia.page-setup(..config),
  header-ascent: 16mm,
  header: context {
    marginalia.notecounter.update(0)
    let book = marginalia._config.get().book
    let leftm = marginalia.get-left()
    let rightm = marginalia.get-right()
    if here().page() > 1 {
      wideblock(
        double: true,
        {
          box(
            width: leftm.width,
            {
              if not (book) or calc.odd(here().page()) [
                Page
                #counter(page).display("1 of 1", both: true)
              ] else [
                #datetime.today().display("[day]. [month repr:long] [year]")
              ]
            },
          )
          h(leftm.sep)
          box(width: 1fr, smallcaps[Marginalia])
          h(rightm.sep)
          box(
            width: rightm.width,
            {
              if not (book) or calc.odd(here().page()) [
                #datetime.today().display("[day]. [month repr:long] [year]")
              ] else [
                Page
                #counter(page).display("1 of 1", both: true)
              ]
            },
          )
        },
      )
    }
  },
  background: context {
    let leftm = marginalia.get-left()
    let rightm = marginalia.get-right()
    place(
      dx: leftm.far,
      rect(width: leftm.width, height: 100%, stroke: (x: luma(90%))),
    )
    place(
      dx: leftm.far + leftm.width + leftm.sep,
      rect(width: 10pt, height: 100%, stroke: (left: luma(90%))),
    )
    place(
      right,
      dx: -rightm.far,
      rect(width: rightm.width, height: 100%, stroke: (x: luma(90%))),
    )
    place(
      right,
      dx: -rightm.far - rightm.width - rightm.sep,
      rect(width: 10pt, height: 100%, stroke: (right: luma(90%))),
    )
  },
)

#set par(justify: true)
#set text(fill: luma(30))
#show link: underline

#v(16mm)
#block(
  text(size: 3em, weight: "black")[
    Marginalia
    #text(size: 11pt)[#note(numbered: false)[
        #outline(indent: 1em, depth: 2)
      ]]],
)
_Write into the margins!_
#v(1em)

#show heading.where(level: 1): set heading(numbering: "1.1")
#show heading.where(level: 2): set heading(numbering: "1.1")

= Setup
Put something akin to the following at the start of your `.typ` file:
#block[
  #set text(size: 0.84em)
  ```typst
  #import "@preview/marginalia:0.1.2" as marginalia: note, wideblock
  #let config = (
    // inner: ( far: 5mm, width: 15mm, sep: 5mm ),
    // outer: ( far: 5mm, width: 15mm, sep: 5mm ),
    // top: 2.5cm,
    // bottom: 2.5cm,
    // book: false,
    // clearance: 8pt,
    // flush-numbers: false,
    // numbering: /* numbering-function */,
  )
  #marginalia.configure(..config)
  #set page(
    // setup margins:
    ..marginalia.page-setup(..config),
    /* other page setup */
  )
  ```
]

Where you can then customize `config` to your preferences. Shown here (as comments) are the default values taken if the corresponding keys are unset.

See the appendix for a more detailed explanation of the #link(label("marginalia-configure()"), [```typc configure()```])
and #link(label("marginalia-page-setup()"), [```typc page-setup()```])
functions.


// // #context if calc.even(here().page()) {pagebreak(to: "odd", weak: true)}
// #pagebreak(to: "odd", weak: true)
// = Showcase
// (or all pages ```typst #if book = false```)

= Margin-Notes
By default, the #link(label("marginalia-note()"))[```typst #note[...]```] command places a note to the right/outer margin, like so:#note[
  This is a note.

  They can contain any content, and will wrap within the note column.
  // #note[Sometimes, they can even contain other notes! (But not always, and I don't know what gives.)]
].
By giving the argument ```typc reverse: true```, we obtain a note on the left/inner margin.#note(reverse: true)[Reversed.]
If ```typc config.book = true```, the side will of course be adjusted automatically.

If~#note[Note 1] we~#note[Note 2] place~#note[Note 3] multiple~#note[Note 4] notes~#note[Note 5] in~#note(dy:15pt)[This note was given ```typc 15pt``` dy, but it was shifted more than that to avoid Notes 1--5.] one~#note(reverse: true, dy:15pt)[This note was given ```typc 15pt``` dy.] line,#note(dy:10cm)[This note was given ```typc 10cm``` dy.] they automatically adjust their positions.
Additionally, a ```typc dy``` argument can be passed to shift their initial position by that amount vertically. They may still get shifted around.

Notes will shift downwards to avoid previous notes, containing wideblocks, and the top page margin. Notes will shift upwards to avoid later notes and wideblocks, and the bottom page margin. However, if there is not enough space between two wideblocks or between wideblocks and the margins, there will be collisions.

#text(fill: red)[TODO: OUTDATED]
Currently, notes (and wideblocks) are not reordered,
#note[This note lands below the previous one!]
so two ```typ #note```s are placed in the same order vertically as they appear in the markup, even if the first is shifted with a `dy` such that the other would fit above it.

#columns(3)[
  Margin notes also work from within most containers such as blocks or ```typ #column()```s.#note(keep-order: true)[#lorem(4)]
  #colbreak()
  Blah blah.#note[Note from second column.]
  To force the notes to appear in the margin in the same order as they appear in the text,
  #colbreak()
  use ```typ #note(keep-order: true)[]```#note(keep-order: true)[Like so. The lorem-ipsum note was also placed with `keep-order`.]
  for _all_ notes whose relative order is important.
]

== Markers
The margin notes are decorated with little symbols, which by default hang into the gap. If this is not desired, set the configuration option ```typc flush-numbers: true```.
Setting the argument ```typc numbered: false```, we obtain notes without icon/number.#note(numbered: false)[Like this.]

To change the markers, you can override ```typc config.numbering```-function which is used to generate the markers.

#text(fill: red)[TODO: OUTDATED]
It is recommended to reset the `notecounter` regularly, either per page:
#block[
  #set text(size: 0.84em)
  ```typ
  #set page(header: { marginalia.notecounter.update(0) })
  ```
]
or per heading:
#block[
  #set text(size: 0.84em)
  ```typ
  #show heading.where(level: 1): it =>
    { marginalia.notecounter.update(0); it }
  ```
]
// #note[
//   Vertical offsets in this document:
//   Right:\
//   #context marginalia._note_extends_right.get().at("1") \
//   #context marginalia._note_extends_right.final().at("1") \
//   #context marginalia._note_offset_right("1") \
//   #context marginalia._note_offset_right("2") \
//   #context marginalia._note_offset_right("3") \
//   #context marginalia._note_offset_right("4") \
//   #context marginalia._note_offset_right("5") \
//   #context marginalia._note_offset_right("6") \
//   #context marginalia._note_offset_right("7") \
//   #context marginalia._note_offset_right("8")

//   Left:\
//   #context marginalia._note_offset_left("1") \
//   #context marginalia._note_offset_left("2") \
//   #context marginalia._note_offset_left("3") \
//   #context marginalia._note_offset_left("4") \
//   #context marginalia._note_offset_left("5") \
//   #context marginalia._note_offset_left("6") \
//   #context marginalia._note_offset_left("7") \
//   #context marginalia._note_offset_left("8")
// ]

= Wide Blocks
#wideblock[
  The command
  ```typst #wideblock[...]```
  can be used to wrap content in a wide block which spans into the margin-note-column.
  It is possible to use notes in a wide block:#note[Voila.]#note(reverse: true)[Wow!].
  They will automatically shift downwards to avoid colliding with the wideblock.
]

#wideblock(reverse: true)[
  ```typst #wideblock(reverse: true)[...]```: The `reverse` option makes the block extend to the inside margin instead.
  
  This is analogous to the `reverse` option on notes.
  #note[Notes above a `wideblock` will shift upwards if necessary.]
]

#wideblock(double: true)[
  ```typst #wideblock(double: true)[...]```: The `double` option makes it extend both ways.
  Note that setting both `reverse: true` and `double: true` is disallowed and will panic.
]

= Figures

For small figures, you can place them in the margin with ```typc marginalia.notefigure```.
#marginalia.notefigure(
  rect(width: 100%, fill: gradient.linear(..color.map.mako)),
  caption: [A notefigure.],
)
It accepts all arguments `figure` takes (except `placement` and `scope`), plus all arguments `note` takes. However, by default it has no marker, and to get a marker like other notes, you must pass ```typc numbered: true```, it will get a marker like other notes:
#marginalia.notefigure(
  rect(width: 100%, fill: gradient.linear(..color.map.turbo)),
  numbered: true,
  label: <markedfigure>,
  caption: [A marked notefigure.],
)

Additionally, the `dy` argument now takes a relative length, where ```typc 100%``` is the height of the figure content + gap, but without the caption.
By default, figures have a `dy` of ```typc 0pt - 100%```, which results in the caption being aligned horizontally to the text.
#marginalia.notefigure(
  dy: 0pt,
  rect(width: 100%, fill: gradient.linear(..color.map.crest)),
  numbered: true,
  caption: [Aligned to top of figure with `dy: 0pt`.],
)

A label can be attached to the figure using the `label` argument.// C.f.~@markedfigure.

For larger figures, use the following set and show rules:
#block[
  #set text(size: 0.84em)
  ```typ
  #set figure(gap: 0pt)
  #set figure.caption(position: top)
  #show figure.caption.where(position: top):
                                note.with(numbered: false, dy: 1em)
  ```
]

#set figure(gap: 0pt)
#set figure.caption(position: top)
#show figure.caption.where(position: top): note.with(numbered: false, dy: 1em)

#figure(
  rect(width: 100%, fill: gradient.linear(..color.map.inferno)),
  caption: [A figure.],
)

For wide figures, simply place a figure in a wideblock.
The Caption gets placed beneath the figure automatically, courtesy of regular wide-block-avoidance.
#block[
  #set text(size: 0.84em)
  ```typ
  #wideblock[#figure(
    image(...),
    caption: [A figure in a wide block.]
  )]
  ```
]
// #pagebreak(weak: true)
#wideblock[
  #figure(
    rect(width: 100%, fill: gradient.linear(..color.map.cividis)),
    caption: [A figure in a wide block.],
  )
]
#wideblock(reverse: true)[
  #figure(
    rect(width: 100%, height: 5em, fill: gradient.linear(..color.map.icefire)),
    caption: [A figure in a reversed wide block.],
  )
]
#wideblock(double: true)[
  #figure(
    rect(width: 100%, fill: gradient.linear(..color.map.spectral)),
    caption: [A figure in a double-wide block.],
  )
]

= Headers and Background
This is not (yet) a polished feature and requires to access ```typc marginalia._config.get().book``` to read the respective config option.
In your documents, consider removing this check and simplifying the ```typc if``` a bit.
#note[Also, please don't ```typc .update()``` the `marginalia._config` directly, this can easily break the notes.]


Here's how the headers in this document were made:
#block[
  #set text(size: 0.84em)
  ```typst
  #set page(header: context {
    marginalia.notecounter.update(0)
    let book = marginalia._config.get().book
    let leftm = marginalia.get-left()
    let rightm = marginalia.get-right()
    if here().page() > 1 {
      wideblock(double: true, {
        box(width: leftm.width, {
          if not (book) or calc.odd(here().page()) [
            Page
            #counter(page).display("1 of 1", both: true)
          ] else [
            #datetime.today().display(/**/)
          ]
        })
        h(leftm.sep)
        box(width: 1fr, smallcaps[Marginalia])
        h(rightm.sep)
        box(width: rightm.width, {
          if not (book) or calc.odd(here().page()) [
            #datetime.today().display(/**/)
          ] else [
            Page
            #counter(page).display("1 of 1", both: true)
          ]
        })
      })
    }
  })
  ```
]

And here's the code for the lines in the background:
#note[
  Not that you should copy them, they're mostly here to showcase the columns and help me verify that everything gets placed in the right spot.
]
#block[
  #set text(size: 0.84em)
  ```typst
  #set page(background: context {
    let leftm = marginalia.get-left()
    let rightm = marginalia.get-right()
    place(
      dx: leftm.far,
      rect(width: leftm.width, height: 100%,
        stroke: (x: luma(90%))))
    place(
      dx: leftm.far + leftm.width + leftm.sep,
      rect(width: 10pt, height: 100%,
        stroke: (left: luma(90%))))
    place(right,
      dx: -rightm.far,
      rect(width: rightm.width, height: 100%,
        stroke: (x: luma(90%))))
    place(right,
      dx: -rightm.far - rightm.width - rightm.sep,
      rect(width: 10pt, height: 100%,
        stroke: (right: luma(90%))))
  })
  ```
]

= Trobleshooting / Known Bugs

- If the document needs multiple passes to figure out page-breaks,
  #note[This can happen for example with outlines which barely fit/don't fit onto the page.]
  it can break the note positioning.
  - This can usually be resolved by placing a ```typ #pagebreak()``` or ```typ #pagebreak(weak: true)``` in an appropriat location.

- Nested notes may or may not work.
  #note[
    #text(fill: red)[TODO: OUTDATED]
    In this manual, for example, it works here, but not on the first page.
    // #note[I don't know why... :(]
  ]
  In all cases, they seem to lead to a "layout did not converge within 5 attempts" warning, so it is probably best to avoid them if possible.

- If you encounter anything else which looks like a big to you, please #link("https://github.com/nleanba/typst-marginalia/issues")[create an "issue" on Github] if noone else has done so already.

= Thanks
Many thanks go to Nathan Jessurun for their #link("https://typst.app/universe/package/drafting")[drafting] package,
which has served as a starting point and was very helpful in figuring out how to position margin-notes.

The `wideblock` functionality was inspired by the one provided in the #link("https://typst.app/universe/package/tufte-memo")[tufte-memo] template.

Also shout-out to #link("https://typst.app/universe/package/tidy")[tidy], which was used to produce the appendix.

// #pagebreak()
// = Testing
// Ignore this page.

// #{
//   let render-offsets(page, items) = {
//     let offsets = marginalia._calculate-offsets(page, items, 5pt)
//     block(height: page.height, width: 100%, stroke: 1pt + black, inset: 0pt, {
//       place(top, dy: page.top, line(length: 100%, stroke: 1pt + green))
//       for key in items.keys() {
//         place(top+left, dy: items.at(key).natural, rect(width: 50%, height: items.at(key).height, fill: blue.transparentize(70%), {
//           key
//           if items.at(key).shift != true [S: #items.at(key).shift ]
//           if items.at(key).reorder [ R]
//           }))

//         place(top+right, dy: items.at(key).natural + offsets.at(key), rect(width: 50%, height: items.at(key).height, fill: red.transparentize(70%), {
//           if items.at(key).shift != true [S: #items.at(key).shift ]
//           if items.at(key).reorder [R ]
//           key
//           }))
//       }
//       place(bottom, dy: -page.bottom, line(length: 100%, stroke: 1pt + green))
//     })
//   }

//   let page = (height: 150pt, top: 10pt, bottom: 10pt)
//   grid(columns: 2, gutter: 10pt,
//   render-offsets(page, (
//     "1": (natural: 5pt, height: 20pt, shift: true, reorder: false),
//     "2": (natural: 67pt, height: 20pt, shift: false, reorder: true),
//     "3": (natural: 62pt, height: 20pt, shift: true, reorder: false),
//     "4": (natural: 72pt, height: 20pt, shift: true, reorder: false),
//   )),
//   render-offsets(page, (
//     "1": (natural: 5pt, height: 20pt, shift: true, reorder: false),
//     "2": (natural: 67pt, height: 20pt, shift: true, reorder: false),
//     "3": (natural: 62pt, height: 20pt, shift: false, reorder: true),
//     "4": (natural: 72pt, height: 20pt, shift: true, reorder: false),
//   )),
//   render-offsets(page, (
//     "1": (natural: 5pt, height: 20pt, shift: true, reorder: false),
//     "2": (natural: 52pt, height: 20pt, shift: true, reorder: false),
//     "3": (natural: 67pt, height: 20pt, shift: "avoid", reorder: false),
//     "4": (natural: 77pt, height: 20pt, shift: true, reorder: false),
//   )),
//   render-offsets(page, (
//     "1": (natural: 5pt, height: 20pt, shift: true, reorder: false),
//     "2": (natural: 20pt, height: 20pt, shift: true, reorder: false),
//     "3": (natural: 52pt, height: 20pt, shift: "avoid", reorder: false),
//     "4": (natural: 62pt, height: 20pt, shift: true, reorder: false),
//   )),
//   render-offsets(page, (
//     "1": (natural: 5pt, height: 20pt, shift: true, reorder: false),
//     "2": (natural: 62pt, height: 20pt, shift: true, reorder: false),
//     "3": (natural: 52pt, height: 20pt, shift: "avoid", reorder: true),
//     "4": (natural: 69pt, height: 20pt, shift: true, reorder: false),
//   )),
//   render-offsets(page, (
//     "1": (natural: 5pt, height: 20pt, shift: true, reorder: false),
//     "2": (natural: 12pt, height: 20pt, shift: true, reorder: false),
//     "3": (natural: 52pt, height: 20pt, shift: false, reorder: true),
//     "4": (natural: 62pt, height: 20pt, shift: true, reorder: false),
//   )),
//   render-offsets(page, (
//     "1": (natural: 5pt, height: 20pt, shift: true, reorder: false),
//     "2": (natural: 45pt, height: 20pt, shift: "avoid", reorder: false),
//     "3": (natural: 50pt, height: 20pt, shift: true, reorder: false),
//     "4": (natural: 85pt, height: 50pt, shift: true, reorder: false),
//   )),
//   )

//   pagebreak()
//   grid(columns: 2, gutter: 10pt,
//   render-offsets(page, (
//     "1": (natural: 5pt, height: 20pt, shift: true, reorder: true),
//     "2": (natural: 67pt, height: 20pt, shift: false, reorder: true),
//     "3": (natural: 62pt, height: 20pt, shift: true, reorder: true),
//     "4": (natural: 72pt, height: 20pt, shift: true, reorder: true),
//   )),
//   render-offsets(page, (
//     "1": (natural: 5pt, height: 20pt, shift: true, reorder: true),
//     "2": (natural: 67pt, height: 20pt, shift: true, reorder: true),
//     "3": (natural: 62pt, height: 20pt, shift: false, reorder: true),
//     "4": (natural: 72pt, height: 20pt, shift: true, reorder: true),
//   )),
//   render-offsets(page, (
//     "1": (natural: 5pt, height: 20pt, shift: true, reorder: true),
//     "2": (natural: 52pt, height: 20pt, shift: true, reorder: true),
//     "3": (natural: 67pt, height: 20pt, shift: "avoid", reorder: true),
//     "4": (natural: 77pt, height: 20pt, shift: true, reorder: true),
//   )),
//   render-offsets(page, (
//     "1": (natural: 5pt, height: 20pt, shift: true, reorder: true),
//     "2": (natural: 20pt, height: 20pt, shift: true, reorder: true),
//     "3": (natural: 52pt, height: 20pt, shift: "avoid", reorder: true),
//     "4": (natural: 62pt, height: 20pt, shift: true, reorder: true),
//   )),
//   render-offsets(page, (
//     "1": (natural: 5pt, height: 20pt, shift: true, reorder: true),
//     "2": (natural: 62pt, height: 20pt, shift: true, reorder: true),
//     "3": (natural: 52pt, height: 20pt, shift: "avoid", reorder: true),
//     "4": (natural: 69pt, height: 20pt, shift: true, reorder: true),
//   )),
//   render-offsets(page, (
//     "1": (natural: 5pt, height: 20pt, shift: true, reorder: true),
//     "2": (natural: 12pt, height: 20pt, shift: true, reorder: true),
//     "3": (natural: 52pt, height: 20pt, shift: false, reorder: true),
//     "4": (natural: 62pt, height: 20pt, shift: true, reorder: true),
//   )),
//   render-offsets(page, (
//     "1": (natural: 5pt, height: 20pt, shift: true, reorder: true),
//     "2": (natural: 45pt, height: 20pt, shift: "avoid", reorder: true),
//     "3": (natural: 50pt, height: 20pt, shift: true, reorder: true),
//     "4": (natural: 85pt, height: 50pt, shift: true, reorder: true),
//   )),
//   )
// }


// no more book-style to allow for multipage wideblock
#marginalia.configure(..config, book: false)
#set page(
  ..marginalia.page-setup(..config, book: false),
)
#context counter(heading).update(0)
#show heading.where(level: 1): set heading(numbering: "A.1", supplement: "Appendix")
#show heading.where(level: 2): set heading(numbering: "A.1", supplement: "Appendix")//, outlined: false)

#wideblock(reverse: true)[
  = Detailed Documentation of all Exported Symbols
  <appendix>

  #import "@preview/tidy:0.4.1"
  #let docs = tidy.parse-module(
    read("lib.typ"),
    name: "marginalia",
    // preamble: "notecounter.update(1);",
    scope: (
      notecounter: marginalia.notecounter,
      note-numbering: marginalia.note-numbering,
      note-markers: marginalia.note-markers,
      note-markers-alternating: marginalia.note-markers-alternating,
      marginalia: marginalia,
      internal: (..text) => {
        let text = text.pos().at(0, default: [Internal.])
        note(numbered: false, text)
        h(0pt, weak: true)
        // set text(fill: white, weight: 600, size: 9pt)
        // block(fill: luma(40%), inset: 2pt, outset: 2pt, radius: 2pt, body)
      },
    ),
  )

  #tidy.show-module(
    docs,
    // sort-functions: false,
    // style: tidy.styles.minimal,
    first-heading-level: 1,
    // show-outline: false,
    omit-private-definitions: true,
    omit-private-parameters: false,
    show-module-name: false,
    break-param-descriptions: true,
    // omit-empty-param-descriptions: false,
  )
]
