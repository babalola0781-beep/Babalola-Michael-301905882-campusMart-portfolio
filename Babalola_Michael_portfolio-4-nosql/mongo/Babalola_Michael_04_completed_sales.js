(() => {
  const campusmart = db.getSiblingDB("campusmart_nosql");

  print("Completed-order sales by category using purchase-time item prices");
  printjson(
    campusmart.orders.aggregate([
      { $match: { status: "completed" } },
      { $unwind: "$items" },
      {
        $group: {
          _id: "$items.category",
          unitsSold: { $sum: "$items.quantity" },
          salesNGN: {
            $sum: { $multiply: ["$items.unitPrice", "$items.quantity"] }
          }
        }
      },
      {
        $project: {
          _id: 0,
          category: "$_id",
          unitsSold: 1,
          salesNGN: 1
        }
      },
      { $sort: { salesNGN: -1, category: 1 } }
    ]).toArray()
  );
})();
