#import "../../lib.typ" as marginalia: note, notefigure, wideblock

#set page(width: 20cm, height: auto)
#show: marginalia.setup.with(
  inner: (far: 1cm, width: 2cm, sep: 1cm),
  outer: (far: 1cm, width: 4cm, sep: 1cm),
  top: 2cm,
  bottom: 2cm,
  book: true,
)
#show: marginalia.show-frame

// using basic numbering as the ci runner does not have Inter
#let note = note.with(numbering: (..i) => super(numbering("1", ..i)))

This page has ```typc height: auto```. As a consequence, Marginalia cannot know where the bottom
page margin is, and notes may run over the bottom of the page.
#note[#lorem(20)]