#import "lib.typ" as marginalia: note, wideblock

#let config = (
  inner: ( far: 16mm, width: 18mm, sep: 8mm ),
  outer: ( far: 16mm, width: 40mm, sep: 8mm ),
  top: 32mm + 1em, bottom: 16mm,
  book: true,
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
    Marginalia#note(numbered: false)[
  #outline(indent: 2em, depth: 2)
]
  ],
)
_Write into the margins!_
#v(1em)

#show heading.where(level: 1): set heading(numbering: "1.1")
#show heading.where(level: 2): set heading(numbering: "1.1")

= Setup
Put something akin to the following at the start of your `.typ` file:
// #note[
//   Alternatively, use
// ```typ
// #import "path_to_marginalia" as marginalia: note, wideblock
// ```
// ]
#block[
  #set text(size: 0.84em)
  ```typst
  #import "@preview/marginalia:0.1.0" as marginalia: note, wideblock
  #let config = (
    // inner: ( far: 5mm, width: 15mm, sep: 5mm ),
    // outer: ( far: 5mm, width: 15mm, sep: 5mm ),
    // top: 2.5cm,
    // bottom: 2.5cm,
    // book: false,
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

See the appendix for a more detailed explanation of the #link(label("marginaliaconfigure()"), [```typc configure()```])
and #link(label("marginaliapage-setup()"), [```typc page-setup()```])
functions.


// // #context if calc.even(here().page()) {pagebreak(to: "odd", weak: true)}
// #pagebreak(to: "odd", weak: true)
// = Showcase
// (or all pages ```typst #if book = false```)

= Margin-Notes
By default, the #link(label("marginalianote()"))[```typst #note[...]```] command places a note to the right/outer margin, like so:#note[
  This is a note.

  They can contain any content, and will wrap within the note column.
].
By giving the argument ```typc reverse: true```, we obtain a note on the left/inner margin.#note(reverse: true)[Reversed.]
If ```typc config.book = true```, the side will of course be adjusted automatically.

If~#note[Note 1] we~#note[Note 2] place~#note[Note 3] multiple~#note[Note 4] notes~#note[Note 5] in~#note(dy:15pt)[This note was given ```typc 15pt``` dy.] one~#note(dy:100pt)[This note was given ```typc 100pt``` dy.] line,#note(reverse: true, dy:15pt)[This note was given ```typc 15pt``` dy.] they automatically adjust their positions.
Additionally, a ```typc dy``` argument can be passed to shift their initial position by that amount vertically. They may still get shifted around.

== Markers
The margin notes are decorated with little symbols, which by default hang into the gap. If this is not desired, set the configuration option ```typc flush-numbers: true```.
Setting the argument ```typc numbered: false```, we obtain notes without icon/number.#note(numbered: false)[Like this.]

To change the markers, you can override ```typc config.numbering```-function which is used to generate the markers.

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
  It is a bit cluttered, but is possible to use notes in wide blocks:#note(reverse: true)[Voila], but make sure to set the ```typc reverse``` argument appropriately.//#note[Or ensure that the notes don't overlap the wide block some other way.]
]

#wideblock(reverse: true)[
  ```typst #wideblock(reverse: true)[...]```: The `reverse` option makes the block extend to the inside margin instead.
  #lorem(13)
]

#wideblock(double: true)[
  ```typst #wideblock(double: true)[...]```: The `double` option makes it extend both ways.
  Note that setting both `reverse: true` and `double: true` will panic.
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
#note[
  Also, this is a good place to show that the notes will shift upwards to fit within the page.
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

= Thanks
Many thanks go to Nathan Jessurun for their #link("https://typst.app/universe/package/drafting")[drafting] package,
which has served as a starting point and was very helpful in figuring out how to position margin-notes.

The `wideblock` functionality was inspired by the one provided in the #link("https://typst.app/universe/package/tufte-memo")[tufte-memo] template.

Also shout-out to #link("https://typst.app/universe/package/tidy")[tidy], which was used to produce the appendix.

// #pagebreak(to: "even", weak: true)
// = Even Page
// == Margin-Notes
// Margin notes adjust themselves to even pages.#note[Ta-dah!]
// Here, to get to the right margin, now the inner margin, we use reversed notes.#note(reverse: true)[Comme ça.]


// == Wide Blocks

// #wideblock[
//   ```typst #wideblock[...]```
//   #lorem(20)
// ]

// #wideblock(reverse: true)[
//   ```typst #wideblock(reverse: true)[...]```:
//   #lorem(17)
// ]

// #wideblock(double: true)[
//   ```typst #wideblock(double: true)[...]```:
//   #lorem(24)
// ]

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

  #import "@preview/tidy:0.3.0"
  #let docs = tidy.parse-module(
    read("lib.typ"),
    name: "marginalia",
    preamble: "notecounter.update(1);",
    scope: (
      notecounter: marginalia.notecounter,
      as-note: marginalia.as-note,
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
    // style: tidy.styles.minimal,
    first-heading-level: 1,
    show-outline: false,
    omit-private-definitions: true,
    omit-private-parameters: true,
    show-module-name: false,
    // omit-empty-param-descriptions: false,
  )
]
