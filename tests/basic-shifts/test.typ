#import "../../lib.typ" as marginalia: note, notefigure, wideblock

#set page(width: 20cm, height: 14cm)
#show: marginalia.setup.with(
  inner: (far: 1cm, width: 2cm, sep: 1cm),
  outer: (far: 1cm, width: 4cm, sep: 1cm),
  top: 2cm,
  bottom: 2cm,
  book: true,
)

// using basic numbering as the ci runner does not have Inter
#let note = note.with(numbering: (..i) => super(numbering("1", ..i)))

If~#note[Note 1] we~#note[Note 2] place~#note[Note 3] multiple~#note[Note 4] notes~#note[Note 5]
in~#note(dy: 15pt)[This note was given ```typc 15pt``` dy, but it was shifted more than that to avoid Notes 1--5.]
one~#note(side: "inner", dy: 15pt)[This note was given ```typc 15pt``` dy.]
line,#note(dy: 10cm)[This note was given ```typc 10cm``` dy and was shifted less than that to stay on the page.]
they automatically adjust their positions.
Additionally, a ```typc dy``` argument can be passed to shift their initial position by that amount
vertically. They may still get shifted around, unless configured otherwise via the ```typc shift```
parameter of ```typst #note[]```.

#pagebreak()


If~#note[Note 1] we~#note[Note 2] place~#note[Note 3] multiple~#note[Note 4] notes~#note[Note 5]
in~#note(dy: 15pt)[This note was given ```typc 15pt``` dy, but it was shifted more than that to avoid Notes 1--5.]
one~#note(side: "inner", dy: 15pt)[This note was given ```typc 15pt``` dy.]
line,#note(dy: 10cm)[This note was given ```typc 10cm``` dy and was shifted less than that to stay on the page.]
they automatically adjust their positions.
Additionally, a ```typc dy``` argument can be passed to shift their initial position by that amount
vertically. They may still get shifted around, unless configured otherwise via the ```typc shift```
parameter of ```typst #note[]```.
