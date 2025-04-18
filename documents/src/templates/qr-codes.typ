#import "@preview/tiaoma:0.3.0"

#let qr-codes-grid(title: "") = {
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
    #grid(
      columns: (1fr, 1fr, 1fr, 1fr),
      rows: (auto, 60pt),
      gutter: 5pt,
      ..items.map(item => {
          tiaoma.barcode(item.url, "QRCode")
      })
)
  ]
}

#show: doc => qr-codes-grid(
  title: sys.inputs.at("product_title"),
)

