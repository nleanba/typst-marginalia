#import "../../lib.typ" as marginalia: note, notefigure, wideblock

#set page(width: 20cm, height: 25cm)
#show: marginalia.setup.with(
  inner: (far: 1cm, width: 2cm, sep: 1cm),
  outer: (far: 1cm, width: 4cm, sep: 1cm),
  top: 2cm,
  bottom: 2cm,
  book: true,
)

#set heading(numbering: "1.a")

// using basic numbering as the ci runner does not have Inter
#let note = note.with(numbering: (..i) => super(numbering("1", ..i)))


- Original: #note[This is a note]<label>
- Label Reference: @label @label2
- Offset Reference: #marginalia.ref(-1) #marginalia.ref(1)
- Original: #note[This is another note]<label2>

#line()

- Notefigure: #notefigure(
    rect(width: 100%, height: 10pt, fill: gradient.linear(..color.map.turbo)),
    numbering: (..i) => super(numbering("1", ..i)),
    caption: [A marked notefigure.],
    note-label: <markedfigure_note>,
  )<markedfigure>
- Figure reference: @markedfigure
- Label Reference: @markedfigure_note
- Offset Reference: #marginalia.ref(-1)

#line()

- Notefigure: #notefigure(
    rect(width: 100%, height: 10pt, fill: gradient.linear(..color.map.turbo)),
    caption: [A marked notefigure.],
    note-label: <figure_note>,
  )<figure>
- Figure reference: @figure
- Label Reference: @figure_note
- Offset Reference: #marginalia.ref(-1)

= Other References

#figure(table(columns: 2)[A][B][C][D], caption: [abcd])<plain_figure>
→ @plain_figure

#import "@preview/theoretic:0.2.0": theorem, show-ref
#show ref: show-ref
#theorem(label: <thm>)[Blah]
→ @thm

== Citations <heading>

→ @clark1990unit
→ @heading

#bibliography("bib.yml")