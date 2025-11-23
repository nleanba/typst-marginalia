#import "../../lib.typ" as marginalia: note, notefigure, wideblock

#set page(width: 20cm, height: 25cm)
#show: marginalia.setup.with(
  inner: (far: 1cm, width: 1cm, sep: 1cm),
  outer: (far: 0.5cm, width: 4cm, sep: 0.5cm),
  top: 2cm,
  bottom: 2cm,
  book: true,
)

#set heading(numbering: "1.a")

// using basic numbering as the ci runner does not have Inter
#let note = note.with(numbering: (..i) => super(numbering("1", ..i)))
#let notefigure = notefigure.with(numbering: (..i) => super(numbering("1", ..i)))

#let note = note.with(side: "near")
#let notefigure = notefigure.with(side: "near")
```typ
#let note = note.with(side: "near")
#let notefigure = notefigure.with(side: "near")
```

#for i in range(46) [#box(
    width: 7pt,
    inset: (y: 2pt),
    fill: gradient.linear(..color.map.vlag).sample(100% * i / 45),
    align(center, (note[])),
  )#h(1fr)]

#columns(2)[
  #lorem(30)
  #note[Left]
  #notefigure(
    rect(width: 100%, height: 10pt, fill: gradient.linear(..color.map.plasma)),
    caption: [Left],
  )
  #colbreak()
  #lorem(30)
  #note[Right]
  #notefigure(
    rect(width: 100%, height: 10pt, fill: gradient.linear(..color.map.plasma)),
    caption: [Right],
  )
]
