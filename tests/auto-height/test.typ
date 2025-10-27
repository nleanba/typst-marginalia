#import "../../lib.typ" as marginalia: note, notefigure, wideblock

#set page(width: 20cm, height: auto)
#show: marginalia.setup.with(
  inner: (far: 1cm, width: 2cm, sep: 1cm),
  outer: (far: 1cm, width: 4cm, sep: 1cm),
  top: 2cm,
  bottom: 2cm,
  book: true,
  clearance: 10pt,
)
#show: marginalia.show-frame

// using basic numbering as the ci runner does not have Inter
#let note = note.with(numbering: (..i) => super(numbering("1", ..i)))

#let note = note.with(keep-order: true)

This page has ```typc height: auto```. As a consequence, Marginalia cannot know where the bottom
page margin is, and notes may run over the bottom of the page.
#note[#lorem(20)]
#note[#lorem(20)]

To avoid this#note[However, notes may then run over the top of the page...], place the following at the end of the page:
```typ #context note(shift: false, alignment: "top", dy: marginalia._config.get().clearance, keep-order: true, numbering: none, anchor-numbering: auto)[]```
#context note(shift: false, alignment: "top", dy: marginalia._config.get().clearance, keep-order: true, numbering: none, anchor-numbering: auto)[]