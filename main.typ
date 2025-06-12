#import "lib.typ" as marginalia: note, wideblock

#let config = (
  inner: (far: 16mm, width: 20mm, sep: 8mm),
  outer: (far: 16mm, width: 40mm, sep: 8mm),
  top: 32mm + 11pt,
  bottom: 16mm,
  book: true,
  // clearance: 30pt,
  // flush-numbers: false,
)

#show: marginalia.setup.with(..config)

// testing html
// #show: everything => context {
//   if target() == "paged" {
#set page(
  // ..marginalia.page-setup(..config),
  header-ascent: 16mm,
  header: context {
    // marginalia.notecounter.update(0)
    let book = marginalia._config.get().book
    let leftm = marginalia.get-left()
    let rightm = marginalia.get-right()
    if here().page() > 1 {
      wideblock(
        side: "both",
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
      top,
      dy: marginalia._config.get().top,
      line(length: 100%, stroke: 0.5pt + luma(90%)),
    )
    place(
      top,
      dy: marginalia._config.get().top - page.header-ascent,
      line(length: 100%, stroke: 0.5pt + luma(90%)),
    )
    place(
      bottom,
      dy: -marginalia._config.get().bottom,
      line(length: 100%, stroke: 0.5pt + luma(90%)),
    )
    place(
      dx: leftm.far,
      rect(
        width: leftm.width,
        height: 100%,
        stroke: (x: 0.5pt + luma(90%)),
        inset: 0pt,
        {
          // place(
          //   top,
          //   dy: marginalia._config.get().top,
          //   line(length: 100%, stroke: luma(90%)),
          // )
        },
      ),
    )
    place(
      dx: leftm.far + leftm.width + leftm.sep,
      rect(width: 10pt, height: 100%, stroke: (left: 0.5pt + luma(90%))),
    )
    place(
      right,
      dx: -rightm.far,
      rect(width: rightm.width, height: 100%, stroke: (x: 0.5pt + luma(90%))),
    )
    place(
      right,
      dx: -rightm.far - rightm.width - rightm.sep,
      rect(width: 10pt, height: 100%, stroke: (right: 0.5pt + luma(90%))),
    )
  },
)
//     everything
//   } else {
//     everything
//   }
// }

#show heading.where(level: 1): set block(above: 42pt, below: 14pt)
#show heading.where(level: 2): set block(above: 28pt, below: 12pt)

#set par(justify: true, linebreaks: "optimized")
#set text(fill: luma(30), size: 10pt)
#show raw: set text(font: ("IBM Plex Mono", "DejaVu Sans Mono"))
#show link: underline

#let codeblock(code) = {
  wideblock(
    side: "inner",
    {
      // #set text(size: 0.84em)
      block(stroke: 0.5pt + luma(90%), fill: white, width: 100%, inset: (y: 5pt), code)
    },
  )
}

#v(16mm)
#block(
  text(size: 3em, weight: "black")[
    Marginalia
    #text(size: 10pt)[#note(numbering: none)[
        #outline(indent: 1em, depth: 2)
      ]]],
)
_Write into the margins!_
#v(1em)

#show heading.where(level: 1): set heading(numbering: "1.1")
#show heading.where(level: 2): set heading(numbering: "1.1")

= Setup
Put something akin to the following at the start of your `.typ` file:
#codeblock[
  ```typst
  #import "@preview/marginalia:0.2.0" as marginalia: note, wideblock

  #show: marginalia.setup.with(
    // inner: ( far: 5mm, width: 15mm, sep: 5mm ),
    // outer: ( far: 5mm, width: 15mm, sep: 5mm ),
    // top: 2.5cm,
    // bottom: 2.5cm,
    // book: false,
    // clearance: 12pt,
  )
  ```
]

Where you can then customize these options to your preferences.
Shown here (as comments) are the default values taken if the corresponding keys are unset.
#note[You can also skip the configuration step if you’re happy with these defaults, but 15mm is not a lot to write in.]

If `book` is `false`, `inner` and `outer` correspond to the left and right
margins respectively. If book is true, the margins swap sides on even and odd
pages. Notes are placed in the outside margin by default.

See the appendix for a more detailed explanation of the #link(label("marginalia-setup()"), [```typc setup()```]) function and its options.

Additionally, I recommend using typst’s partial function application feature to customize other aspects of the notes:
#codeblock[
  ```typ
  #let note = note.with(/* options here */)
  ```
]


// // #context if calc.even(here().page()) {pagebreak(to: "odd", weak: true)}
// #pagebreak(to: "odd", weak: true)
// = Showcase
// (or all pages ```typst #if book = false```)

= Margin-Notes
By default, the #link(label("marginalia-note()"))[```typst #note[...]```] command places a note to the right/outer margin, like so:#note[
  This is a note.

  They can contain any content, and will wrap within the note column.
  // #note(dy: -1em)[Sometimes, they can even contain other notes! (But not always, and I don't know what gives.)]
].
By giving the argument ```typc side: "inner"```, we obtain a note on the inner (left) margin.#note(side: "inner")[Reversed.]
If ```typc config.book = true```, the side will of course be adjusted automatically.
It is also possible to pass ```typc side: "left"``` or ```typc side: "right"``` if you want a fixed side even in books.

If~#note[Note 1] we~#note[Note 2] place~#note[Note 3] multiple~#note[Note 4] notes~#note[Note 5] in~#note(dy:15pt)[This note was given ```typc 15pt``` dy, but it was shifted more than that to avoid Notes 1--5.] one~#note(side: "inner", dy:15pt)[This note was given ```typc 15pt``` dy.] line,#note(dy:10cm)[This note was given ```typc 10cm``` dy and was shifted less than that to stay on the page.] they automatically adjust their positions.
Additionally, a ```typc dy``` argument can be passed to shift their initial position by that amount vertically. They may still get shifted around, unless configured otherwise via the #link(label("marginalia-note.shift"))[```typc shift```] parameter of ```typ #note()```.

Notes will shift vertically to avoid other notes, wideblocks, and the top page margin.
It will attempt to move one note below a wide-block if there is not enough space above, but if there are multiple notes that would need to be rearranged you must assist by manually setting `dy` such that their initial position is below the wideblock.

// #text(fill: red)[TODO: OUTDATED]
// Currently, notes (and wideblocks) are not reordered,
// #note[This note lands below the previous one!]
// so two ```typ #note```s are placed in the same order vertically as they appear in the markup, even if the first is shifted with a `dy` such that the other would fit above it.

// #pagebreak(weak: true)
#columns(3)[
  Margin notes also work from within most containers such as blocks or ```typ #column()```s.#note(keep-order: true)[#lorem(4)]
  #colbreak()
  Blah blah.#note[Note from second column.]
  To force the notes to appear in the margin in the same order as they appear in the text, use
  #colbreak()
  ```typ #note(keep-order: true)[]```#note(keep-order: true)[Like so. The lorem-ipsum note was also placed with `keep-order`.]
  for _all_ notes whose relative order is important.
]

== Markers
The margin notes are decorated with little symbols, which by default hang into the gap. If this is not desired, set ```typc flush-numbering: true``` on the note.
#note(flush-numbering: true)[
  This note has flush numbering.
]
(This is sadly not possible to do for `notefigure`s.)

Setting the argument ```typc numbering: none```,#note[Unnumbered notes ```typc "avoid"``` being shifted if possible, preferring to shift other notes up.]
we obtain notes without icon/number:#note(numbering: none)[Like this.]

To change the markers, you can override ```typc config.numbering```-function which is used to generate the markers.

== Styling
Both #link(label("marginalia-note()"))[```typc note()```] and #link(label("marginalia-notefigure()"))[```typc notefigure()```]
accept `text-style`, `par-style`, and `block-style` parameters:
- ```typc text-style: (size: 5pt, font: ("Iosevka Extended"))``` gives~#note(text-style: (size: 5pt, font: ("Iosevka Extended")))[#lorem(10)]
- ```typc par-style: (spacing: 20pt, leading: -2pt)``` gives~#note(par-style: (spacing: 20pt, leading: -2pt))[
    #lorem(10)

    #lorem(4)
  ]

The default options here are meant to be as close as possible to the stock footnote style.

I strongly recommend setting a fixed text-size for your notes (```typc size: __pt``` instead of ```typc size: __em```) to ensure consistent sizing of the notes independent on the font size of the surrounding text.

=== `block-style`
#let note-with-separator = marginalia.note.with(
  block-style: (
    stroke: (top: (thickness: 0.5pt, dash: "dotted")),
    outset: (top: 6pt /* clearance is 12pt */),
    width: 100%,
  ),
)
#let note-with-wide-background = marginalia.note.with(
  block-style: (fill: oklch(90%, 0.06, 140deg), outset: (left: 10pt, rest: 4pt), width: 100%, radius: 4pt),
)
#let note-with-background = marginalia.note.with(
  block-style: (fill: oklch(90%, 0.06, 140deg), inset: (x: 4pt), outset: (y: 4pt), width: 100%, radius: 4pt),
)
To style the block containing the note body, use the `block-style` argument.

- ```typc block-style: (stroke: (top: (thickness: 0.5pt, dash: "dotted")), outset: (top: 6pt /* clearance is 12pt */), width: 100%)``` gives:
  #note-with-separator(keep-order: true)[This is a note with a dotted stroke above.]
  #note-with-separator(numbering: none, keep-order: true, shift: true)[So is this.]
- ```typc block-style: (fill: oklch(90%, 0.06, 140deg), outset: (left: 10pt, rest: 4pt), width: 100%, radius: 4pt)``` gives:
  #note-with-background(flush-numbering: true, keep-order: true)[This is a note with a green background and `flush-numbering: true`.]
  #note-with-background(numbering: none, keep-order: true, shift: true)[So is this.]

- ```typc block-style: (fill: oklch(90%, 0.06, 140deg), inset: (x: 4pt), outset: (y: 4pt), width: 100%, radius: 4pt)``` gives:
  #note-with-wide-background(keep-order: true)[This is a note with an outset green background.]
  #note-with-wide-background(numbering: none, keep-order: true, shift: true)[So is this.]

For more advanced use-cases, you can also pass a function as the `block-style`. It will be called with one argument, either ```typc "left"``` of ```typc "right"```, depending on the side the note will be placed on.
Additionally, inside the function context is avaliable if neccessary.
#let block-style = (side) => {
  if side == "left" {
    (stroke: (left: none, rest: 0.5pt + purple), outset: (left: marginalia.get-left().far, rest: 4pt))
  } else {
    (stroke: (right: none, rest: 0.5pt + purple), outset: (right: marginalia.get-right().far, left: 9pt, rest: 4pt))
  }
}
#note(block-style: block-style)[Purple]
#note(side: "inner", block-style: block-style)[Purple 2]

#codeblock(```typ
#let block-style = (side) => {
  if side == "left" {
    (stroke: (left: none, rest: 0.5pt + purple), outset: (left: marginalia.get-left().far, rest: 4pt))
  } else {
    (stroke: (right: none, rest: 0.5pt + purple), outset: (right: marginalia.get-right().far, left: 9pt, rest: 4pt))
  }
}
#note(block-style: block-style)[Purple]
#note(side: "inner", block-style: block-style)[Purple 2]
```)

// #codeblock(```typ
// #let note-with-wide-background = marginalia.note.with(
//     block-style: (fill: oklch(90.26%, 0.058, 140.43deg), outset: (left: 10pt, rest: 4pt), width: 100%, radius: 4pt)
//   )
// #let note-with-background = marginalia.note.with(
//     block-style: (fill: oklch(90.26%, 0.058, 140.43deg), inset: (x: 4pt), outset: (y: 4pt), width: 100%, radius: 4pt)
//   )
// ```)

//
// #text(fill: red)[TODO: OUTDATED]
// It is recommended to reset the `notecounter` regularly, either per page:
// #block[
//   #set text(size: 0.84em)
//   ```typ
//   #set page(header: { marginalia.notecounter.update(0) })
//   ```
// ]
// or per heading:
// #block[
//   #set text(size: 0.84em)
//   ```typ
//   #show heading.where(level: 1): it =>
//     { marginalia.notecounter.update(0); it }
//   ```
// ]
//
// #note(shift: "ignore")[
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

// #pagebreak(weak: true)
= Wide Blocks
#wideblock[
  The command
  ```typst #wideblock[...]```
  can be used to wrap content in a wide block which spans into the margin-note-column.

  Note: when using an asyymetric page layout with `book: true`, wideblocks which span across pagebreaks are messy, because there is no way for the wideblock to detect the pagebreak and adjust ist position after it.

  It is possible to use notes in a wide block:#note[Voila.]#note(side: "inner")[Wow!].
  They will automatically shift downwards to avoid colliding with the wideblock.
  #note(dy: -8em)[Unless they are given a `dy` argument moving them above the block.]
]

#wideblock(side: "inner")[
  ```typst #wideblock(side: "inner")[...]```: The `side` option allows extending the block into the inside margin instead.
  This is analogous to the `side` option on notes and allows placing notes in their usual column.

  In this manual, an inner wideblock is used to set the appendix to make it take up fewer pages.
  This is also why the appendix is no longer using `book: true`.
  #note[Notes above a `wideblock` will shift upwards if necessary.]
]

#wideblock(side: "both")[
  ```typst #wideblock(side: "both")[...]```: Additionally, wideblocks can extend on both sides, for extra wide content...
]

// #pagebreak(weak: true)
= Figures

== Notefigures
For small figures, you can place them in the margin with ```typc marginalia.notefigure```.
#marginalia.notefigure(
  rect(width: 100%, height: 15pt, fill: gradient.linear(..color.map.mako)),
  caption: [A notefigure.],
)
It accepts all arguments `figure` takes (except `placement` and `scope`), plus all arguments `note` takes (except `align-baseline`). However, by default it has no marker, and to get a marker like other notes, you must pass ```typc numbering: marginalia.note-numbering```, it will get a marker like other notes:
#marginalia.notefigure(
  rect(width: 100%, height: 15pt, fill: gradient.linear(..color.map.turbo)),
  numbering: marginalia.note-numbering,
  label: <markedfigure>,
  caption: [A marked notefigure.],
)

Additionally, the `dy` argument now takes a relative length, where ```typc 100%``` is the distance between the top of the figure content and the first baseline of the caption.
//height of the figure content + gap, but without the caption.
By default, figures have a `dy` of ```typc 0pt - 100%```, which results in the caption being aligned horizontally to the text.
#marginalia.notefigure(
  dy: 0pt,
  rect(width: 100%, height: 15pt, fill: gradient.linear(..color.map.crest)),
  numbering: marginalia.note-numbering,
  caption: [Aligned to top of figure with `dy: 0pt`.],
)

A label can be attached to the figure using the `label` argument, as was done here for @markedfigure.

Notefigures can also be given `side`, `text-style`, `par-style` and `block-style` parameters,
as demonstrated in @styled-fig.
#marginalia.notefigure(
  side: "inner",
  rect(width: 100%, height: 15pt, stroke: 0.5pt + purple),
  caption: [Styled figure.],
  block-style: block-style,
  text-style: (size: 5pt, font: ("Iosevka Extended")),
  par-style: (spacing: 20pt, leading: 0pt),
  label: <styled-fig>,
)

== Large Figures
For larger figures, use the following set and show rules:
#codeblock[
  ```typ
  #set figure(gap: 0pt)
  #set figure.caption(position: top)
  #show figure.caption.where(position: top): note.with(numbering:none, dy:1em)
  ```
]

#set figure(gap: 0pt)
#set figure.caption(position: top)
#show figure.caption.where(position: top): note.with(numbering: none, dy: 1em)

#figure(
  rect(width: 100%, fill: gradient.linear(..color.map.inferno)),
  caption: [A figure.],
)

For wide figures, simply place a figure in a wideblock.
The caption gets placed beneath the figure automatically, courtesy of regular wide-block-avoidance.
#codeblock[
  ```typ
  #wideblock(figure(image(..), caption: [A figure in a wide block.]))
  ```
]
// #pagebreak(weak: true)
#wideblock[
  #figure(
    rect(width: 100%, fill: gradient.linear(..color.map.cividis)),
    caption: [A figure in a wide block.],
  )
]
#wideblock(side: "inner")[
  #figure(
    rect(width: 100%, height: 5em, fill: gradient.linear(..color.map.icefire)),
    caption: [A figure in a reversed wide block.],
  )
]
#wideblock(side: "both")[
  #figure(
    rect(width: 100%, fill: gradient.linear(..color.map.spectral)),
    caption: [A figure in an extra-wide wideblock.],
  )
]

= Other Tidbits
== Absolute Placement
You can place notes in absolute positions relative to the page using `place`:
#codeblock[
  ```typ
  #place(top, note(numbering: none, side: "inner")[Top])
  #place(bottom, note(numbering: none, side: "inner")[Bottom])
  ```
]
#place(top, note(numbering: none, side: "inner")[Top])
#place(bottom, note(numbering: none, side: "inner")[Bottom])

To avoid these notes moving about, use `shift: false` (or `shift: "ignore"` if you don't mind overlaps.)
#codeblock[
  // #set text(size: 0.84em)
  ```typ
  #place(top, note(numbering: none, shift: false)[Top (no shift)])
  #place(bottom, note(numbering: none, shift: false)[Bottom (no shift)])
  ```
]
#place(top, note(numbering: none, shift: false)[Top (no shift)])
#place(bottom, note(numbering: none, shift: false)[Bottom (no shift)])

By default, notes are aligned to their first baseline.
To align the top of the note instead, set #link(label("marginalia-note.align-baseline"))[```typc align-baseline```] to ```typc false```.
#place(top, note(numbering: none, shift: false, align-baseline: false)[Top (no shift, no baseline align)])
#place(bottom, note(numbering: none, shift: false, align-baseline: false)[Bottom (no shift, no baseline al.)])

== Headers and Background
This is not (yet) a polished feature and requires to access ```typc marginalia._config.get().book``` to read the respective config option.
In your documents, consider removing this check and simplifying the ```typc if``` a bit.
#note[Also, please don't ```typc .update()``` the `marginalia._config` directly, this can easily break the notes.]


Here's how the headers in this document were made:
#codeblock[
  // #set text(size: 0.84em)
  ```typst
  #set page(header: context {
    marginalia.notecounter.update(0)
    let book = marginalia._config.get().book
    let leftm = marginalia.get-left()
    let rightm = marginalia.get-right()
    if here().page() > 1 {
      wideblock(side: "both", {
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
#codeblock[
  // #set text(size: 0.84em)
  ```typst
  #set page(background: context {
    let leftm = marginalia.get-left()
    let rightm = marginalia.get-right()
    place(top, dy: marginalia._config.get().top,
          line(length: 100%, stroke: luma(90%)))
    place(top, dy: marginalia._config.get().top - page.header-ascent,
          line(length: 100%, stroke: luma(90%)))
    place(bottom, dy: -marginalia._config.get().bottom,
          line(length: 100%, stroke: luma(90%)))
    place(dx: leftm.far,
          rect(width: leftm.width, height: 100%, stroke: (x: luma(90%))))
    place(dx: leftm.far + leftm.width + leftm.sep,
          rect(width: 10pt, height: 100%, stroke: (left: luma(90%))))
    place(right, dx: -rightm.far,
          rect(width: rightm.width, height: 100%, stroke: (x: luma(90%))))
    place(right, dx: -rightm.far - rightm.width - rightm.sep,
          rect(width: 10pt, height: 100%, stroke: (right: luma(90%))))
  })
  ```
]

// #pagebreak(weak: true)
= Troubleshooting / Known Bugs

- If the document needs multiple passes to figure out page-breaks,
  #note[This can happen for example with outlines which barely fit/don't fit onto the page.]
  it can break the note positioning.
  - This can usually be resolved by placing a ```typ #pagebreak()``` or ```typ #pagebreak(weak: true)``` in an appropriate location.

- Nested notes may or may not work.
  #note[
    In this manual, for example, it works fine (with warnings) here,
    #note[Probably because there aren't many other notes around.]
    but not on the first page.
    #note(side: "inner")[Notes on the other side are usually fine though.]
  ]
  In nearly all cases, they seem to lead to a "layout did not converge within 5 attempts" warning, so it is probably best to avoid them if possible.
  - Just use multiple paragraphs in one note, or place multiple notes in the main text instead.
  - If really neccessary, use `shift: "ignore"` on the nested notes and manually set `dy`.

- `notefigure`s does not take a `flush-numbering` parameter,
  because it is not easily possible for this package to insert the marker _into_ the caption#note[Which is a block-level element] without adding a newline.

- If `book` is `true`, wideblocks that break across pages are broken. Sadly there doesn't seem to be a way to detect and react to page-breaks from within a `block`, so I don't know how to fix this.

- If you encounter anything else which looks like a bug to you, please #link("https://github.com/nleanba/typst-marginalia/issues")[create an "issue" on GitHub] if no-one else has done so already.

= Thanks
Many thanks go to Nathan Jessurun for their #link("https://typst.app/universe/package/drafting")[drafting] package,
which has served as a starting point and was very helpful in figuring out how to position margin-notes.
// Also check out #link("https://typst.app/universe/package/marge/")[marge] by Eric Biedert which helped motivate me to polish this package to not look bad in comparison.

The `wideblock` functionality was inspired by the one provided in the #link("https://typst.app/universe/package/tufte-memo")[tufte-memo] template.

Also shout-out to #link("https://typst.app/universe/package/tidy")[tidy], which was used to produce the appendix.

(This project is not affiliated with #link("https://marginalia-search.com/"), but that is _also_ a cool project.)


// testing html
// #context { if target() == "paged" [

// no more book-style to allow for multipage wideblock
#show: marginalia.setup.with(..config, book: false)
#context counter(heading).update(0)
#show heading.where(level: 1): set heading(numbering: "A.1", supplement: "Appendix")
#show heading.where(level: 2): set heading(numbering: "A.1", supplement: "Appendix", outlined: false)

#let compat(versions) = {
  show heading.where(level: 4): set block(above: 4pt, below: 4pt)
  show heading.where(level: 4): set text(size: 8pt)
  block(
    fill: oklch(99%, 0.02, 30deg),
    width: 100%,
    inset: (y: 4pt),
    outset: (x: 2pt),
    {
      [=== Breaking Changes]
      for (version, changes) in versions {
        [==== #version]
        for change in changes {
          [- #change]
        }
      }
    }
  )
}
#let ergo(do) = {
  linebreak()
  h(30pt)
  box(width: 1fr, {
    h(-15pt)
    box(width: 15pt)[→]
    do
  })
}

#wideblock(side: "inner")[
  = Detailed Documentation of all Exported Symbols <appendix>

  #compat((
    "1.5.0": (
      [The functions `configure()` and `page-setup()` have been combined into one #link(label("marginalia-setup()"), [```typc setup()```]) function.],
    )
  ))

  #import "@preview/tidy:0.4.2"
  #import "tidy-style.typ" as style
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
      compat: compat,
      ergo: ergo,
      internal: (..text) => {
        let text = text.pos().at(0, default: [Internal.])
        note(numbering: none, text)
        h(0pt, weak: true)
        // set text(fill: white, weight: 600, size: 9pt)
        // block(fill: luma(40%), inset: 2pt, outset: 2pt, radius: 2pt, body)
      },
    ),
  )

  #tidy.show-module(
    docs,
    // sort-functions: false,
    style: style,
    first-heading-level: 1,
    // show-outline: false,
    omit-private-definitions: true,
    // omit-private-parameters: false,
    show-module-name: false,
    // break-param-descriptions: true,
    // omit-empty-param-descriptions: false,
  )
]
