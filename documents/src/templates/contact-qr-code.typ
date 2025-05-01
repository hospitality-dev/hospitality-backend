#import "@preview/tiaoma:0.3.0"
#set text(font: "Lato")
#let qr-codes-grid(title: "", contact: "") = {
  set document(title: title, author: "Hospitality - IMS")
  set page(
    paper: "a4",
    margin: (x: 1cm, y: 1cm),
  )
  align(center)[
    #block(text(weight: "bold", size: 18pt)[#title])
    #v(0.5cm)
  ]

  // Import JSON data if provided
  let items = json(bytes(sys.inputs.at("json")))

  block(width: 100%)[
    #tiaoma.barcode(item.url, "QRCode", options: (scale(100%))),
  ]
}

#show: doc => qr-codes-grid(
  title: sys.inputs.at("title"),
  contact: sys.inputs.at("contact"),
)

