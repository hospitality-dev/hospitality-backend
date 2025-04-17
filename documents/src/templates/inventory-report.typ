#set text(
  font: "Lato"
)
#let warning(title, hasAboutToExpire) = table.cell(fill: if hasAboutToExpire == true { luma(150)} else {luma(250)}, text(fill: black, title, weight: if hasAboutToExpire == true {"semibold"} else {"regular"} , size: 12pt))
#let inventory-list(title: "Inventory List") = {
  // Document setup
  set document(title: title, author: "Hospitality - IMS")
  set page(
    paper: "a4",
    margin: (x: 1cm, y: 1cm),
  )
  // Title and header
  align(center)[
    #block(text(weight: "bold", size: 18pt)[#title])
    #v(0.5cm)
  ]

  // Date of report
  align(right)[
    Generated on: #datetime.today().display("[day padding:zero].[month padding:zero].[year]")
    #v(0.5cm)
  ]

  // Import JSON data if provided
  let inventory-data = json(bytes(sys.inputs.at("json")))



  // Create table with inventory data

  block(width: 100%)[
    #table(
      columns: (1fr, 0.75fr, 0.5fr, ),
      inset: (5pt, 5pt, 5pt, 5pt),
      align: (left + horizon, center + horizon, center + horizon),
      stroke: 1pt,
      // Table header
      [*Item Name*], [*Expiration Date*], [*Count*],
      // Table data
      ..inventory-data.map(item => {

          (
          warning(item.title, item.hasAboutToExpire),
          warning(text([#item.expirationDate #item.expirationDays]), item.hasAboutToExpire),
          warning(str(item.count), item.hasAboutToExpire)
          )


      }).flatten()
    )
  ]

  // Summary statistics
  let total-items = inventory-data.fold(0, (acc, item) => acc + item.count)

  v(1cm)
  [*Total Items in Inventory: #text([#total-items], size: 12pt)*]

}

// Example usage - uncomment this section to test
#show: doc => inventory-list(
  title: sys.inputs.at("location_title"),
)

