(() => {
  const campusmart = db.getSiblingDB("campusmart_nosql");

  print("Products with stock quantity at or below 10");
  printjson(
    campusmart.products
      .find(
        { stockQuantity: { $lte: 10 } },
        { _id: 1, name: 1, category: 1, currentPrice: 1, stockQuantity: 1 }
      )
      .sort({ stockQuantity: 1, _id: 1 })
      .toArray()
  );
})();
