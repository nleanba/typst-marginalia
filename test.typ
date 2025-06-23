#import "lib.typ": *
#show: show-frame.with(header: false, footer: false)
#set page("a5")
#lorem(3)#note[abc]

#context {
  [#page.width ]
  [#page.height ]
  [#(page.width * 2.5 / 21)]
}