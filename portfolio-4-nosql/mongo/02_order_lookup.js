(() => {
  const campusmart = db.getSiblingDB("campusmart_nosql");

  print("Order CM-1005: customer and purchase-time line items");
  printjson(campusmart.orders.findOne({ _id: "CM-1005" }));

  print("Amina Yusuf order history, newest first");
  printjson(
    campusmart.orders
      .find(
        { "customer.email": "amina@example.test" },
        { _id: 1, orderDate: 1, status: 1, "total.amount": 1, "total.currency": 1 }
      )
      .sort({ orderDate: -1 })
      .toArray()
  );
})();
