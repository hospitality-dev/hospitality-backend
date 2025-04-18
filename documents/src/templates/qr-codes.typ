#import "@preview/tiaoma:0.3.0"
#set text(
  font: "Lato"
)
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
      columns: (1fr, 1fr, 1fr, 1fr, 1fr),
      rows: (60pt),
      column-gutter: 5pt,
      row-gutter: 25pt,
      ..items.map(item => {
          stack(
          dir: ttb,
          spacing: 0.35em,
          text(item.expirationDate, size: 12pt),
          tiaoma.barcode(item.url, "QRCode", options: (scale: 2.5))
          )

      })
)
  ]
}

#show: doc => qr-codes-grid(
  title: sys.inputs.at("product_title"),
)

