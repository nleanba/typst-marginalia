#import "lib.typ" as marginalia: page_setup, note, wideblock

#let config = (
  inner: ( far: 16mm, width: 20mm, sep: 8mm ),
  outer: ( far: 16mm, width: 40mm, sep: 8mm ),
  top: 16mm + 2em, bottom: 16mm,
  book: true,
  // flush_numbers: false,
  // numbering: "a",
)

#marginalia.configure(..config)
#set page(
  ..marginalia.page_setup(..config),
  header: { marginalia.notecounter.update(0) }
)
// #show heading.where(level: 1): it => { marginalia.notecounter.update(0); it }

#set par(justify: true)
#set text(fill: luma(30))
#show link: underline

#block(text(size: 3em, weight: "black")[
  Marginalia
])
_Write into the margins!_
#note(numbered: false)[
  #outline(indent: 2em, depth: 2)
]

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
```typst
#import "@preview/marginalia:version": note, wideblock
#let config = (
  // inner: ( far: 5mm, width: 15mm, sep: 5mm ),
  // outer: ( far: 5mm, width: 15mm, sep: 5mm ),
  // top: 2.5cm,
  // bottom: 2.5cm,
  // book: false,
  // flush_numbers: false,
  // numbering: /* numbering-function */,
)
#marginalia.configure(..config)
#set page(
  // setup margins:
  ..marginalia.page_setup(..config),
  /* other page setup */
)
```

Where you can then customize `config` to your preferences. Shown here (as comments) are the default values taken if the corresponding keys are unset.

See the appendix for a more detailed explanation of the #link(label("marginaliaconfigure()"), [```typc configure()```])
and #link(label("marginaliapage_setup()"), [```typc page_setup()```])
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

If~#note[Note 1] we~#note[Note 2] place/*~#note[Note 3]*/ multiple/*~#note[Note 4]*/ notes/*~#note[Note 5]*/ in one line, they automatically adjust their positions (Up to a limit of apparently up to three. I am not sure why exactly this is, as the shifts should not have cyclical dependencies but it should be able to calculate them in-order).
However, a ```typc dy``` argument can be passed to shift them by that length vertically.

== Markers
The margin notes are decorated with little symbols, which by default hang into the gap. If this is not desired, set the configuration option ```typc flush_numbers: true```.
Setting the argument ```typc numbered: false```, we obtain notes without icon/number.#note(numbered: false)[Like this.]
To change the markers, you can override ```typc config.numbering```-function which is used to generate the markers.

It is recommended to reset the `notecounter` regularly, either per page:
```typ
#set page(
  header: {
    marginalia.notecounter.update(0)
  }
)
```
or per heading:
```typ
#show heading.where(level: 1): it => {
  marginalia.notecounter.update(0)
  it
}
```

= Wide Blocks
#wideblock[
  The command
  ```typst #wideblock[...]```
  can be used to wrap content in a wide block which spans into the margin-note-column.
  It is a bit cluttered, but is possible to use notes in wide blocks:#note(reverse: true)[Voila], but make sure to set the ```typc reverse``` argument appropriately.//#note[Or ensure that the notes don't overlap the wide block some other way.]
]

#wideblock(reverse: true)[
  ```typst #wideblock(reverse: true)[...]```:
  #lorem(27)
]

#wideblock(double: true)[
  ```typst #wideblock(double: true)[...]```:
  #lorem(30)
]

Note that setting both `reverse: true` and `double: true` will panic.

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
  ..marginalia.page_setup(..config, book: false)
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
      }
    )
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