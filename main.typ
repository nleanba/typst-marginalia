#import "lib.typ" as marginalia: note, notefigure, wideblock

#let VERSION = "?.?.?"

#set par(justify: true, linebreaks: "optimized")
#set text(fill: luma(20%), size: 10pt)
#show raw: set text(font: ("Iosevka Term", "IBM Plex Mono", "DejaVu Sans Mono"), size: 1.25 * 0.85em)
#show link: underline

#let config = (
  inner: (far: 16mm, width: 20mm, sep: 8mm),
  outer: (far: 16mm, width: 40mm, sep: 8mm),
  top: 32mm + 11pt,
  bottom: 16mm,
  book: true,
  // clearance: 30pt,
)

#show: marginalia.setup.with(..config)

// testing html
// #show: everything => context {
//   if target() == "paged" {
#set page(
  header-ascent: 16mm,
  header: context if here().page() > 1 {
    marginalia.header(
      text-style: (size: 8.5pt, number-type: "old-style"),
      [Page #counter(page).display("1 of 1", both: true)],
      [#smallcaps[Marginalia] #text(fill: luma(60%))[#VERSION]],
      [],
    )
  },
)
//     everything
//   } else {
//     everything
//   }
// }


#show: marginalia.show-frame.with(footer: false)


#show heading.where(level: 1): set block(above: 30pt, below: 12pt)
#show heading.where(level: 2): set block(above: 20pt, below: 10pt)

#let note = note.with(text-style: (size: 8.5pt))
#let notefigure = notefigure.with(text-style: (size: 8.5pt))

#set figure(gap: 0pt) // neccessary in both cases
#set figure.caption(position: bottom) // (this is the default)
#show figure.caption.where(position: bottom): note.with(
  alignment: "bottom",
  anchor-numbering: none,
  numbering: none,
  shift: "avoid",
  keep-order: true,
)


#let codeblock(code) = {
  wideblock(
    side: "inner",
    {
      set text(size: 0.95em)
      block(stroke: 0.5pt + luma(90%), fill: white, width: 100%, inset: (y: 5pt), code)
    },
  )
}

#set document(title: [Marginalia Manual #VERSION])
#show title: it => {
  v(16mm)
  block(
    text(size: 30pt)[
      #text(weight: "black")[Marginalia]
      #text(fill: luma(60%), number-type: "old-style")[#VERSION]
      #text(size: 10pt)[#note(numbering: none)[
        #outline(indent: 1em, depth: 2)
      ]]],
  )
}

#title()
_Write into the margins!_
#v(1em)

#show heading.where(level: 1): set heading(numbering: "1.1")
#show heading.where(level: 2): set heading(numbering: "1.1")

= Setup
Put something akin to the following at the start of your `.typ` file:
#note[Do not #[```typ #import "...": *```], this will shadow built-in functions.]
#codeblock[#raw(
  block: true,
  lang: "typ",
  "#import \"@preview/marginalia:"
    + VERSION
    + "\" as marginalia: note, notefigure, wideblock

#show: marginalia.setup.with(
  // inner: ( far: 5mm, width: 15mm, sep: 5mm ),
  // outer: ( far: 5mm, width: 15mm, sep: 5mm ),
  // top: 2.5cm,
  // bottom: 2.5cm,
  // book: false,
  // clearance: 12pt,
)",
)]

Where you can then customize these options to your preferences.
Shown here (as comments) are the default values taken if the corresponding keys are unset.

If #link(label("marginalia-setup.book"))[```typc book```] is ```typc false```, `inner` and `outer` correspond to the left and right
margins respectively. If book is true, the margins swap sides on even and odd
pages. Notes are placed in the outside margin by default.

See the appendix for a more detailed explanation of the #link(label("marginalia-setup()"), [```typc setup()```]) function and its options.

Additionally, I recommend using Typst's partial function application feature to customize other aspects of the notes consistently:
#codeblock[
  ```typ
  #let note = note.with(/* options here */)
  #let notefigure = notefigure.with(/* same options here */)
  ```
]

// // #context if calc.even(here().page()) {pagebreak(to: "odd", weak: true)}
// #pagebreak(to: "odd", weak: true)
// = Showcase
// (or all pages ```typst #if book = false```)

= Margin-Notes
By default, the #link(label("marginalia-note()"))[```typst #note[]```] command places a note to the right/outer margin, like so:#note[
  This is a note.

  They can contain any content, and will wrap within the note column.
  // #note(dy: -1em)[Sometimes, they can even contain other notes! (But not always, and I don't know what gives.)]
].
By giving the argument #link(label("marginalia-note.side"))[```typc side```]```typc : "inner"```, we obtain a note on the inner (left) margin.#note(side: "inner")[Reversed.]
If #link(label("marginalia-setup.book"))[```typc setup.book```] is ```typc true```, the side will of course be adjusted automatically.
It is also possible to pass #link(label("marginalia-note.side"))[```typc side```]```typc : "left"``` or #link(label("marginalia-note.side"))[```typc side```]```typc : "right"``` if you want a fixed side even in books.

If~#note[Note 1] we~#note[Note 2] place~#note[Note 3] multiple~#note[Note 4] notes~#note[Note 5] in~#note(dy: 15pt)[This note was given ```typc 15pt``` dy, but it was shifted more than that to avoid Notes 1--5.] one~#note(side: "inner", dy: 15pt)[This note was given ```typc 15pt``` dy.] line,#note(dy: 10cm)[This note was given ```typc 10cm``` dy and was shifted less than that to stay on the page.] they automatically adjust their positions.
Additionally, a ```typc dy``` argument can be passed to shift their initial position by that amount vertically. They may still get shifted around, unless configured otherwise via the #link(label("marginalia-note.shift"))[```typc shift```] parameter of #link(label("marginalia-note()"))[```typst #note[]```].

Notes will shift vertically to avoid other notes, wideblocks, and the top page margin.
It will attempt to move one note below a wide-block if there is not enough space above, but if there are multiple notes that would need to be rearranged you must assist by manually setting `dy` such that their initial position is below the wideblock.

// #pagebreak(weak: true)
#block(height: 59pt)[
  #columns(3)[
    Margin notes also work from within most containers such as ```typ #block[]```s or ```typ #column[]```s.
    #note(keep-order: true)[#lorem(4)]
    By default, they are placed aligned with their anchor.
    #note[Note from second column.]
    To force the notes to appear in the margin in the same order as they appear in the text, set
    #link(label("marginalia-note.keep-order"))[```typc keep-order```]```typ : true```
    #note(keep-order: true)[Like so. The lorem-ipsum note was also placed with `keep-order`.]
    on _all_ notes whose relative order is important.
  ]
]

== Markers
The margin notes are decorated with little symbols, which by default hang into the gap. If this is not desired, set #link(label("marginalia-note.flush-numbering"), [```typc flush-numbering```])```typc : true``` on the note.
#note(flush-numbering: true)[
  This note has flush numbering.
]

To change the markers, you can override the #link(label("marginalia-note.numbering"), [```typc numbering```]) function which is used to generate the markers.

You can also change the #link(label("marginalia-note.counter"), [```typc counter```]) used. This can be useful if you want some of your notes to have independent numbering.
#let a-note-counter = counter("a-note")
#let a-note = note.with(
  counter: a-note-counter,
  numbering: (..i) => text(weight: 900, font: "Inter", size: 5pt, style: "normal", fill: rgb(54%, 72%, 95%), numbering(
    "A",
    ..i,
  )),
)
#a-note[alphabetized note]
#note[regular one]
#a-note[another alphabetized note]
#codeblock[```typ
#let a-note-counter = counter("a-note")
#let a-note = note.with(
  counter: a-note-counter,
  numbering: (..i) => text(weight: 900, font: "Inter", size: 5pt, style: "normal", fill: rgb(54%, 72%, 95%), numbering("A", ..i)),
)
```]

Setting the #link(label("marginalia-note.counter"), [```typc counter```]) to ```typc none```,#note[Unnumbered notes ```typc "avoid"``` being shifted if possible, preferring to shift other notes up.]
we obtain notes without number:#note(counter: none)[Like this.]

=== References

There are two ways to reference another note:

1. You can add a ```typ <label>``` to the note and then ```typ @label``` reference it. Note that any supplement is ignored.
2. You can use #link(label("marginalia-ref()"), [```typc marginalia.ref()```]) and tell it how many notes away the target is.
  This is mostly useful to reference the most recent note again.

  Be aware that notes without anchor/number still count towards the offset, and you can also reference them, but doing so results in an invisible link and is a bit pointless.

#codeblock[```typ
- Original: #note[This is a note]<label>
- Label Reference: @label @label2
- Count Reference: #marginalia.ref(-1) #marginalia.ref(1)
- Original: #note[This is another note]<label2>
```]
- Original: #note[This is a note]<label>
- Label Reference: @label @label2
- Offset Reference: #marginalia.ref(-1) #marginalia.ref(1)
- Original: #note[This is another note]<label2>

=== Advanced Markers

If a different style is desired for the marker in the text and in the margins, you can use the #link(label("marginalia-note.anchor-numbering"), [```typc anchor-numbering```]) parameter to control the in-text marker:
#note(
  numbering: (.., i) => text(font: "Inria Sans")[#i#h(0.5em)],
  anchor-numbering: (.., i) => super[#i],
)[This note has a custom numbering, but the same counter.]
#codeblock[```typ
#note(
  numbering: (.., i) => text(font: "Inria Sans")[#i#h(0.5em)],
  anchor-numbering: (.., i) => super[#i],
)[...]
```]
Note that doing this implies #link(label("marginalia-note.flush-numbering"), [```typc flush-numbering```])```typc : true```.
This is based on the assumption that if you have set two different numbering functions, you want to handle the placement yourself.
Non-flush numbers, which are `place`d, complicate this.

This can also be used to create notes that have an anchor,
#note(
  numbering: none,
  anchor-numbering: (..) => {
    set text(weight: 900, font: "Inter", size: 5pt, style: "normal", fill: rgb(54%, 72%, 95%))
    if calc.even(here().page()) [←] else [→]
  },
)[
  Like this one.
]
but no numbering in the note itself.
#note(
  numbering: (.., i) => text(font: "Inria Sans")[#i#h(0.5em)],
  anchor-numbering: (.., i) => super[#i],
)[(the #link(label("marginalia-notecounter"), [```typc notecounter```]) is unaffected by the previous note, as it has #link(label("marginalia-note.numbering"), [```typc numbering```])```typc : none```)]


== Styling
Both #link(label("marginalia-note()"))[```typc note()```] and #link(label("marginalia-notefigure()"))[```typc notefigure()```]
accept #link(label("marginalia-note.text-style"), [```typc text-style```]),
#link(label("marginalia-note.par-style"), [```typc par-style```]),
and #link(label("marginalia-note.block-style"), [```typc block-style```]) parameters:
- ```typc text-style: (size: 5pt, font: ("Iosevka Extended"))``` gives~#note(text-style: (size: 5pt, font: "Iosevka Extended"))[#lorem(10)]
- ```typc par-style: (spacing: 20pt, leading: -2pt)``` gives~#note(par-style: (spacing: 20pt, leading: -2pt))[
    #lorem(10)

    #lorem(4)
  ]

The default options here are meant to be as close as possible to the stock footnote style given 11pt text.
For other text sizes, set the #link(label("marginalia-note.text-style"), [```typc text-style```]) `size` to 0.85 times your body text size if you want to match the stock footnotes.

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
To style the block containing the note body, use the #link(label("marginalia-note.block-style"), [```typc block-style```]) parameter.

- ```typc block-style: (stroke: (top: (thickness: 0.5pt, dash: "dotted")), outset: (top: 6pt /* clearance is 12pt */), width: 100%)``` gives:
  #note-with-separator(keep-order: true)[This is a note with a dotted stroke above.]
  #note-with-separator(numbering: none, keep-order: true, shift: true)[So is this.]
- ```typc block-style: (fill: oklch(90%, 0.06, 140deg), outset: (left: 10pt, rest: 4pt), width: 100%, radius: 4pt)``` gives:
  #note-with-background(
    flush-numbering: true,
    keep-order: true,
  )[This is a note with a green background and `flush-numbering: true`.]
  #note-with-background(numbering: none, keep-order: true, shift: true)[So is this.]

- ```typc block-style: (fill: oklch(90%, 0.06, 140deg), inset: (x: 4pt), outset: (y: 4pt), width: 100%, radius: 4pt)``` gives:
  #note-with-wide-background(keep-order: true)[This is a note with an outset green background.]
  #note-with-wide-background(numbering: none, keep-order: true, shift: true)[So is this.]

For more advanced use-cases, you can also pass a function as the #link(label("marginalia-note.block-style"), [```typc block-style```]).
It will be called with one argument, either ```typc "left"``` of ```typc "right"```, depending on the side the note will be placed on.
Inside the function, context is available.
#let block-style = side => {
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

#pagebreak(weak: true)
= Wide Blocks
#wideblock[
  The command
  #link(label("marginalia-wideblock()"), [```typ #wideblock[]```])
  can be used to wrap content in a wide block which spans into the margin-note-column.

  Note: when using an asymmetric page layout with #link(label("marginalia-setup.book"), [```typc setup.book```])```typc : true```, wideblocks which span across pagebreaks are messy, because there is no way for the wideblock to detect the pagebreak and adjust its position after it.

  It is possible to use notes in a wide block:#note[Voila.]#note(side: "inner")[Wow!].
  They will automatically shift downwards to avoid colliding with the wideblock.
  #note(
    dy: -10em,
  )[Unless they are given a #link(label("marginalia-note.dy"))[```typ dy```] argument moving them above the block.]
]

#wideblock(side: "inner")[
  ```typst #wideblock(side: "inner")[...]```: The #link(label("marginalia-wideblock.side"), [```typc side```]) option allows extending the block into the inside margin instead.
  This is analogous to the #link(label("marginalia-note.side"), [```typc side```]) option on notes and notefigures and allows placing notes in their usual column.

  In this manual, an inner wideblock is used to set the appendix to make it take up fewer pages.
  This is also why the appendix is no longer using #link(label("marginalia-setup.book"), [```typc setup.book```])```typc : true```.
  #note[Notes above a #link(label("marginalia-wideblock()"), [```typ #wideblock[]```]) will shift upwards if necessary.]
]

#wideblock(side: "both")[
  ```typst #wideblock(side: "both")[...]```: Additionally, wideblocks can extend on both sides, for extra wide content.
  This is especially useful for figures, more on that below.
]

// #pagebreak(weak: true)
= Figures

== Notefigures
For small figures, you can place them in the margin with #link(label("marginalia-notefigure()"), [```typ #notefigure()```]).
#notefigure(
  rect(width: 100%, height: 15pt, fill: gradient.linear(..color.map.mako)),
  caption: [A notefigure.],
);It accepts all arguments ```typ #figure()``` takes (except `placement` and `scope`),
plus all arguments #link(label("marginalia-note()"), [```typ #note[]```]) takes.
However, by default it has no marker, and to get a marker like other notes, you must pass
#link(label("marginalia-notefigure.numbering"))[```typ numbering```]```typc : marginalia.note-numbering```,
and it will get a marker like other notes:
#notefigure(
  rect(width: 100%, height: 10pt, fill: gradient.linear(..color.map.turbo)),
  numbering: marginalia.note-numbering,
  caption: [A marked notefigure.],
  note-label: <markedfigure_note>,
)<markedfigure>

If you want, you can override the #link(label("marginalia-notefigure.counter"))[```typc counter```] and #link(label("marginalia-notefigure.anchor-numbering"))[```typc anchor-numbering```] to get an anchor using the figure-numbering.
#notefigure(
  rect(width: 100%, height: 10pt, fill: gradient.linear(..color.map.crest)),
  caption: [reusing figure counter],
  counter: counter(figure.where(kind: image)),
  anchor-numbering: (.., i) => super[fig. #(i + 1) ],
)

#codeblock[```typ
#notefigure(
  /**/,
  counter: counter(figure.where(kind: image)),
  anchor-numbering: (.., i) => super[fig. #(i + 1) ],
)
```]


Additionally, the #link(label("marginalia-notefigure.alignment"))[```typ alignment```] parameter can now also be ```typc "caption-top"```,
which results in alignment with the top of the caption.
#notefigure(
  alignment: "caption-top",
  rect(width: 100%, height: 10pt, fill: gradient.linear(..color.map.crest)),
  numbering: marginalia.note-numbering,
  caption: [Aligned to top of caption.],
)

By default, like normal #link(label("marginalia-note()"), [```typ #note[]```]);s,
it uses #link(label("marginalia-notefigure.alignment"))[```typc alignment```]```typc : "baseline"```
which leads to the caption's being aligned with the main text.
#notefigure(
  alignment: "top",
  rect(width: 100%, height: 10pt, fill: gradient.linear(..color.map.icefire)),
  numbering: marginalia.note-numbering,
  caption: [Aligned to top of figure with #link(label("marginalia-notefigure.alignment"))[```typc alignment```]```typc : "top"```.],
)

A label can be attached to the figure normally as was done for @markedfigure. You can also add a label to the _note_ by using the #link(label("marginalia-notefigure.note-label"))[```typ note-label```] argument.@markedfigure_note

Notefigures can also be given
#link(label("marginalia-notefigure.side"), [```typc side```]),
#link(label("marginalia-notefigure.text-style"), [```typc text-style```]),
#link(label("marginalia-notefigure.par-style"), [```typc par-style```]),
and #link(label("marginalia-notefigure.block-style"), [```typc block-style```]) parameters,
-- like #link(label("marginalia-note()"), [```typ #note[]```]) --
as is demonstrated in @styled-fig.
#notefigure(
  side: "inner",
  rect(width: 100%, height: 15pt, stroke: 0.5pt + purple),
  caption: [Styled figure.],
  block-style: block-style,
  text-style: (size: 5pt, font: "Iosevka Extended"),
  par-style: (spacing: 20pt, leading: 0pt),
)<styled-fig>
Furthermore, the `numbering`, `anchor-numbering`, and `flush-numbering` parameters work as expected.
#notefigure(
  rect(width: 100%, height: 15pt, fill: gradient.linear(..color.map.plasma)),
  caption: [Figure with custom numbering],
  numbering: (.., i) => text(font: "Inria Sans")[#i#h(0.5em)],
  anchor-numbering: (.., i) => super[#i],
)

Note that ```typ #show figure.caption: /**/``` rules are ignored for #link(label("marginalia-notefigure()"))[```typ #notefigure[]```]s,
use the #link(label("marginalia-notefigure.show-caption"))[```typc show-caption```] parameter instead.
#note[
  NB: #link(label("marginalia-notefigure.show-caption"))[```typc show-caption```] expects a function with two arguments, check the #link(label("marginalia-notefigure.show-caption"))[docs].
]

== Large Figures

// #show figure.caption: block.with(fill: green, width: 100% + 3em)

For larger figures, use the following set and show rules if you want top-aligned captions:
#codeblock[
  ```typ
  #set figure(gap: 0pt) // neccessary in both cases
  #set figure.caption(position: top)
  #show figure.caption.where(position: top): note.with(alignment: "top", anchor-numbering: none, numbering: none, shift: "avoid", keep-order: true)
  ```
]

#[
  #set figure(gap: 0pt)
  #set figure.caption(position: top)
  #show figure.caption.where(position: top): note.with(
    alignment: "top",
    anchor-numbering: none,
    numbering: none,
    shift: "avoid",
    keep-order: true,
  )

  #figure(
    rect(width: 100%, fill: gradient.linear(..color.map.inferno)),
    caption: [A figure.],
  )
]

And if you want bottom-aligned captions, use the following:
#codeblock[
  ```typ
  #set figure(gap: 0pt) // neccessary in both cases
  #set figure.caption(position: bottom) // (this is the default)
  #show figure.caption.where(position: bottom): note.with(alignment: "bottom", anchor-numbering: none, numbering: none, shift: "avoid", keep-order: true)
  ```
]

#figure(
  rect(width: 100%, fill: gradient.linear(..color.map.inferno)),
  caption: [A figure.],
)

=== Wide Figures

For wide figures, simply place a figure in a wideblock.
The caption gets placed beneath the figure automatically, courtesy of regular wide-block-avoidance.
#note(numbering: none)[(this is assuming you have one of the above ```typc show``` rules)]
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

// #pagebreak(weak: true)
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
To align the top of the note instead, set #link(label("marginalia-note.alignment"))[```typc alignment```] to ```typc "top"```.
#note[(Or set #link(label("marginalia-note.alignment"))[```typc alignment```] to ```typc "bottom"``` to align the bottom of the note.)]
#place(top, note(numbering: none, shift: false, alignment: "top")[Top (no shift, top-aligned)])
#place(bottom, note(numbering: none, shift: false, alignment: "top")[Bottom (no shift, top-aligned)])

== Background Lines
They're mostly here to showcase the columns and help me verify that everything gets placed in the right spot, but if you want, you can enable the lines in the background simply by using
#codeblock[```typ
#show: marginalia.show-frame
```]

You can also hide the lines for the header and footer with
#codeblock[```typ
#show: marginalia.show-frame.with(header: false, footer: false)
```]

// #pagebreak(weak: true)

== Headers
Here's how the headers in this document were made:
#codeblock[
  // #set text(size: 0.84em)
  ```typst
  #set page(
    header-ascent: 16mm,
    header: context if here().page() > 1 {
      marginalia.header(
        text-style: (size: 8.5pt, number-type: "old-style"),
        [Page #counter(page).display("1 of 1", both: true)],
        smallcaps[Marginalia],
        datetime.today().display("[day]. [month repr:long] [year]")
      )
    },
  )
  ```
]

The #link(label("marginalia-header()"))[```typ #marginalia.header()```]
#note(numbering: none)[
  Despite the name, this function can be used anywhere, and not solely for headers.
  It simply creates a wideblock and fills it with properly sized ```typc box```es.
]
function is pretty flexible in the arguments it expects.
Any of the following will work:
#codeblock[
  ```typ
  #marginalia.header(                   [outer]) == #marginalia.header[outer]
  #marginalia.header(         [center], [outer]) == #marginalia.header[center][outer]
  #marginalia.header([inner], [center], [outer]) == #marginalia.header[inner][center][outer]

  #marginalia.header(
    even: ([left outer], [center], [right inner]),
    odd: ([left inner], [center], [right outer]),
  )
  ```
]

For convenience, you may pass a #link(label("marginalia-header.text-style"))[`text-style`] parameter also.

#v(1em)
#marginalia.header(
  text-style: (style: "italic"),
  even: ([left outer], block(fill: luma(90%), width: 100%, outset: (y: 3pt))[this is an even page], [right inner]),
  odd: (
    [left inner],
    block(fill: luma(90%), width: 100%, outset: (y: 3pt))[this is on odd page or book is false],
    [right outer],
  ),
)

== Pages with automatic sizing.
Pages with ```typc width: auto``` are not supported at all.

Pages with ```typc height: auto``` work -- with the limitation that notes may run over the bottom of the page as they are not considered by Typst when determining the page height.

There are two workarounds for this: (these can be combined)

+ If there is not enough space on the page to fit the notes, you can add some vertical space (```typ #v(__pt)```) to make the page taller.
+ If there is left-over space above the notes,#note[I.e. moving notes up would make them fit inside the page] you can try the following:

#codeblock[
  ```typ
  // at the TOP of your content (before all notes)
  //   -- this ensures that notes aren’t moved below the “barrier”
  #let note = note.with(keep-order: true)

  /* Your content */

  // at the END of your content
  //   -- this serves as a “barrier” that moves the previous notes up
  #context marginalia.note(shift: false, alignment: "top", dy: marginalia._config.get().clearance, keep-order: true, numbering: none)[]
  ```
]


// #pagebreak(weak: true)
= Troubleshooting / Known Limitations

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
  - If really necessary, use `shift: "ignore"` on the nested notes and manually set `dy`.

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
    },
  )
}
#let ergo(do) = {
  linebreak()
  h(30pt)
  box(
    width: 1fr,
    {
      h(-15pt)
      box(width: 15pt)[→]
      do
    },
  )
}

#wideblock(side: "inner")[
  = Detailed Documentation of all Exported Symbols <appendix>

  #compat((
    "0.2.0": (
      [The functions `configure()` and `page-setup()` have been combined into one #link(label("marginalia-setup()"), [```typc setup()```]) function.],
    ),
  ))

  #block(height: 3em)

  #import "@preview/tidy:0.4.2"
  #import "tidy-style.typ" as style
  #let docs = tidy.parse-module(
    read("lib.typ"),
    name: "marginalia",
    // preamble: "notecounter.update(1);",
    scope: (
      note: marginalia.note,
      notefigure: marginalia.notefigure,
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
