#import "../../lib.typ" as marginalia: note, notefigure, wideblock

#set page(width: 20cm, height: 14cm)
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

#let block-style = side => {
  if side == "left" {
    (stroke: (left: none, rest: 0.5pt + purple), outset: (left: marginalia.get-left().far, rest: 4pt))
  } else {
    (stroke: (right: none, rest: 0.5pt + purple), outset: (right: marginalia.get-right().far, left: 9pt, rest: 4pt))
  }
}

#lorem(20)
#note(block-style: block-style)[Purple]
#note(side: "inner", block-style: block-style)[Purple 2]

#lorem(20)

#notefigure(
  side: "inner",
  rect(width: 100%, height: 15pt, stroke: 0.5pt + purple),
  caption: [Styled figure.],
  block-style: block-style,
  label: <styled-fig>,
)
