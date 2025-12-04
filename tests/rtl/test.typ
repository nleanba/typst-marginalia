#import "../../lib.typ" as marginalia: note, notefigure, wideblock

#set page(width: 22cm, height: 8cm)
#show: marginalia.setup.with(
  inner: (far: 1cm, width: 2cm, sep: 1cm),
  outer: (far: 1cm, width: 4cm, sep: 1cm),
  top: 2cm,
  bottom: 2cm,
  book: false,
)

#set heading(numbering: "1.a")

// using basic numbering as the ci runner does not have Inter
#let note = note.with(numbering: (..i) => super(numbering("1", ..i)))
#let notefigure = notefigure.with(numbering: (..i) => super(numbering("1", ..i)))

#let block-style = side => {
  if side == "left" {
    (stroke: (left: none, rest: 0.5pt + purple), outset: (left: marginalia.get-left().far, right: 9pt, rest: 4pt))
  } else {
    (stroke: (right: none, rest: 0.5pt + purple), outset: (right: marginalia.get-right().far, left: 9pt, rest: 4pt))
  }
}

#show: marginalia.show-frame

#set text(dir: rtl)

// #let note = note.with(numbering: (..i) => super(numbering("١", ..i)))
// #let notefigure = notefigure.with(numbering: (..i) => super(numbering("١", ..i)))

#lorem(10)
#note[note]
#lorem(10)
#note(side:"inner")[inner note]

Hmm.
#note(block-style: block-style)[Purple]
#note(side: "inner", block-style: block-style)[Purple 2]

يولد جميع الناس أحراراً ومتساوين#note[A ومتساوين Z] في الكرامة والحقوق. وهم قد وهبوا العقل والوجدان وعليهم أن يعاملوا بعضهم بعضاً بروح الإخاء.#note[المادة 1]


#set text(dir: ltr)
#marginalia.notecounter.update(0)
#pagebreak()

#lorem(10)
#note[note]
#lorem(10)
#note(side:"inner")[inner note]

Hmm.
#note(block-style: block-style)[Purple]
#note(side: "inner", block-style: block-style)[Purple 2]

يولد جميع الناس أحراراً ومتساوين#note[A ومتساوين Z] في الكرامة والحقوق. وهم قد وهبوا العقل والوجدان وعليهم أن يعاملوا بعضهم بعضاً بروح الإخاء.#note[المادة 1]

