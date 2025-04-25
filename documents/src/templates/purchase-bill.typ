

#set text(font: "Fira Code", size: 10pt) // Use a monospaced font
#set document(title: sys.inputs.at("title"), author: "Hospitality - IMS")
#set page(
    paper: "a4",
    margin: (x: 1cm, y: 1cm),
  )
#let receipt-items = json(bytes(sys.inputs.at("json")))
  #let pat = tiling(size: (30pt, 30pt))[
  #place(line(start: (0%, 0%), end: (100%, 100%)))
  #place(line(start: (0%, 100%), end: (100%, 0%)))
]

#rect(fill: pat, width: 100%, height: 5pt, stroke: 1pt)

#align(center)[#text("COPY OF RECEIPT", size: 12pt)]
#align(center)[#sys.inputs.at("businessTitle")]
#align(center)[#sys.inputs.at("title") | #sys.inputs.at("purchasedAt")]

#rotate(rect(fill: pat, width: 100%, height: 5pt, stroke: 1pt), 180deg)


  #block(width: 100%)[
    #table(
      columns: (1fr, 0.5fr, 0.5fr, 0.5fr),
      inset: (5pt, 5pt, 5pt, 5pt),
      align: (left + horizon, center + horizon, right + horizon, right + horizon),
      stroke: 1pt,
      // Table header
      [*Title*], [*Quantity*], [*Price/Unit*], [*Total* (RSD)],
      // Table data
      ..receipt-items.map(item => {

          (
          [#item.title],
          [#item.quantity],
          [#calc.round(item.pricePerUnit, digits:2)],
          [#calc.round(item.total, digits:2)]
          )


      }).flatten()
    )
  ]
  #block(width: 100%)[
    #table(
      columns: (1fr, 0.5fr, 0.5fr, 0.5fr),
      inset: (5pt, 5pt, 5pt, 5pt),
      align: (left + horizon, center + horizon, center + horizon, center + horizon),
      stroke: 0pt,
      // Table header
      [], [], [], [RSD #text(sys.inputs.at("total"), size: 10pt, weight: "semibold")],
    )
  ]

#align(bottom)[#text("Please note that this is not a substitute for a receipt. It is an automatically generated copy of an existing receipt.", size: 8pt)]