#import "../../lib.typ" as marginalia: note, notefigure, wideblock

#set page(width: 20cm, height: 14cm)
#show: marginalia.setup.with(
  inner: (far: 1cm, width: 2cm, sep: 1cm),
  outer: (far: 1cm, width: 4cm, sep: 1cm),
  top: 2cm,
  bottom: 2cm,
)

// using basic numbering as the ci runner does not have Inter
#let note = note.with(numbering: (..i) => super(numbering("1", ..i)))

#lorem(20)
#note[#lorem(10)]
#note(side: "inner")[#lorem(18)]

#wideblock[
  #lorem(20)
  #note(shift: "ignore")[Ignored #lorem(10)]
  #lorem(10)
]

#lorem(20)
#note[#lorem(10)]
#lorem(20)
#note(shift: "avoid")[Avoid 1 #lorem(10)]
#note(shift: "avoid")[Avoid 2 #lorem(10)]
#note(side: "inner")[#lorem(10)]
#note(side: "inner")[#lorem(5)]

#lorem(20)
#note(side: "inner", shift: false)[Fixed #lorem(5)]
#lorem(20)
