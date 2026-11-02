(() => {
  const campusmart = db.getSiblingDB("campusmart_nosql");
  const collectionNames = campusmart.getCollectionNames();

  if (!collectionNames.includes("products")) {
    campusmart.createCollection("products", {
      validator: {
        $jsonSchema: {
          bsonType: "object",
          required: ["_id", "sku", "name", "category", "currentPrice", "stockQuantity"],
          properties: {
            _id: { bsonType: "string" },
            sku: { bsonType: "string" },
            name: { bsonType: "string" },
            category: { bsonType: "string" },
            currentPrice: { bsonType: "decimal", minimum: NumberDecimal("0.00") },
            stockQuantity: { bsonType: "int", minimum: 0 }
          }
        }
      },
      validationLevel: "strict",
      validationAction: "error"
    });
  }

  if (!collectionNames.includes("orders")) {
    campusmart.createCollection("orders", {
      validator: {
        $jsonSchema: {
          bsonType: "object",
          required: ["_id", "orderReference", "orderDate", "status", "customer", "items", "total"],
          properties: {
            _id: { bsonType: "string" },
            orderReference: { bsonType: "string" },
            orderDate: { bsonType: "date" },
            status: {
              enum: ["completed", "placed", "draft", "cancelled"]
            },
            customer: {
              bsonType: "object",
              required: ["email", "fullName"],
              properties: {
                email: { bsonType: "string" },
                fullName: { bsonType: "string" }
              }
            },
            items: {
              bsonType: "array",
              minItems: 1,
              items: {
                bsonType: "object",
                required: ["sku", "productName", "category", "quantity", "unitPrice"],
                properties: {
                  sku: { bsonType: "string" },
                  productName: { bsonType: "string" },
                  category: { bsonType: "string" },
                  quantity: { bsonType: "int", minimum: 1 },
                  unitPrice: { bsonType: "decimal", minimum: NumberDecimal("0.00") }
                }
              }
            },
            total: {
              bsonType: "object",
              required: ["currency", "amount"],
              properties: {
                currency: { enum: ["NGN"] },
                amount: { bsonType: "decimal", minimum: NumberDecimal("0.00") }
              }
            }
          }
        }
      },
      validationLevel: "strict",
      validationAction: "error"
    });
  }

  const products = [
    { _id: "EL001", sku: "EL001", name: "Student Laptop", category: "Electronics", currentPrice: NumberDecimal("450000.00"), stockQuantity: NumberInt(10) },
    { _id: "EL002", sku: "EL002", name: "Wireless Mouse", category: "Electronics", currentPrice: NumberDecimal("8500.00"), stockQuantity: NumberInt(40) },
    { _id: "EL003", sku: "EL003", name: "USB Flash Drive", category: "Electronics", currentPrice: NumberDecimal("12000.00"), stockQuantity: NumberInt(25) },
    { _id: "BK001", sku: "BK001", name: "Database Systems Textbook", category: "Books", currentPrice: NumberDecimal("18000.00"), stockQuantity: NumberInt(20) },
    { _id: "BK002", sku: "BK002", name: "A5 Notebook", category: "Books", currentPrice: NumberDecimal("1500.00"), stockQuantity: NumberInt(100) },
    { _id: "CL001", sku: "CL001", name: "Campus T-shirt", category: "Clothing", currentPrice: NumberDecimal("6500.00"), stockQuantity: NumberInt(30) },
    { _id: "CL002", sku: "CL002", name: "Campus Hoodie", category: "Clothing", currentPrice: NumberDecimal("18000.00"), stockQuantity: NumberInt(12) },
    { _id: "AC001", sku: "AC001", name: "Student Backpack", category: "Accessories", currentPrice: NumberDecimal("14000.00"), stockQuantity: NumberInt(18) },
    { _id: "AC002", sku: "AC002", name: "Water Bottle", category: "Accessories", currentPrice: NumberDecimal("4500.00"), stockQuantity: NumberInt(35) },
    { _id: "AC003", sku: "AC003", name: "Compact Umbrella", category: "Accessories", currentPrice: NumberDecimal("5500.00"), stockQuantity: NumberInt(0) }
  ];

  const orders = [
    {
      _id: "CM-1001", orderReference: "CM-1001", orderDate: ISODate("2026-10-01T08:00:00.000Z"), status: "completed",
      customer: { email: "amina@example.test", fullName: "Amina Yusuf" },
      items: [
        { sku: "EL001", productName: "Student Laptop", category: "Electronics", quantity: NumberInt(1), unitPrice: NumberDecimal("450000.00") },
        { sku: "EL002", productName: "Wireless Mouse", category: "Electronics", quantity: NumberInt(2), unitPrice: NumberDecimal("8500.00") }
      ],
      total: { currency: "NGN", amount: NumberDecimal("467000.00") }
    },
    {
      _id: "CM-1002", orderReference: "CM-1002", orderDate: ISODate("2026-10-01T09:30:00.000Z"), status: "completed",
      customer: { email: "tunde@example.test", fullName: "Tunde Bello" },
      items: [
        { sku: "BK001", productName: "Database Systems Textbook", category: "Books", quantity: NumberInt(1), unitPrice: NumberDecimal("18000.00") },
        { sku: "BK002", productName: "A5 Notebook", category: "Books", quantity: NumberInt(4), unitPrice: NumberDecimal("1500.00") }
      ],
      total: { currency: "NGN", amount: NumberDecimal("24000.00") }
    },
    {
      _id: "CM-1003", orderReference: "CM-1003", orderDate: ISODate("2026-10-02T11:15:00.000Z"), status: "completed",
      customer: { email: "chidinma@example.test", fullName: "Chidinma Okeke" },
      items: [
        { sku: "CL001", productName: "Campus T-shirt", category: "Clothing", quantity: NumberInt(2), unitPrice: NumberDecimal("6500.00") },
        { sku: "AC001", productName: "Student Backpack", category: "Accessories", quantity: NumberInt(1), unitPrice: NumberDecimal("14000.00") }
      ],
      total: { currency: "NGN", amount: NumberDecimal("27000.00") }
    },
    {
      _id: "CM-1004", orderReference: "CM-1004", orderDate: ISODate("2026-10-03T13:00:00.000Z"), status: "completed",
      customer: { email: "emeka@example.test", fullName: "Emeka Obi" },
      items: [
        { sku: "EL003", productName: "USB Flash Drive", category: "Electronics", quantity: NumberInt(2), unitPrice: NumberDecimal("12000.00") },
        { sku: "AC002", productName: "Water Bottle", category: "Accessories", quantity: NumberInt(1), unitPrice: NumberDecimal("4500.00") }
      ],
      total: { currency: "NGN", amount: NumberDecimal("28500.00") }
    },
    {
      _id: "CM-1005", orderReference: "CM-1005", orderDate: ISODate("2026-10-04T10:00:00.000Z"), status: "completed",
      customer: { email: "amina@example.test", fullName: "Amina Yusuf" },
      items: [
        { sku: "CL002", productName: "Campus Hoodie", category: "Clothing", quantity: NumberInt(1), unitPrice: NumberDecimal("18000.00") },
        { sku: "BK001", productName: "Database Systems Textbook", category: "Books", quantity: NumberInt(1), unitPrice: NumberDecimal("16000.00") }
      ],
      total: { currency: "NGN", amount: NumberDecimal("34000.00") }
    },
    {
      _id: "CM-1006", orderReference: "CM-1006", orderDate: ISODate("2026-10-05T12:30:00.000Z"), status: "placed",
      customer: { email: "zainab@example.test", fullName: "Zainab Musa" },
      items: [
        { sku: "AC001", productName: "Student Backpack", category: "Accessories", quantity: NumberInt(1), unitPrice: NumberDecimal("14000.00") },
        { sku: "AC003", productName: "Compact Umbrella", category: "Accessories", quantity: NumberInt(1), unitPrice: NumberDecimal("5500.00") }
      ],
      total: { currency: "NGN", amount: NumberDecimal("19500.00") }
    },
    {
      _id: "CM-1007", orderReference: "CM-1007", orderDate: ISODate("2026-10-06T07:45:00.000Z"), status: "draft",
      customer: { email: "tunde@example.test", fullName: "Tunde Bello" },
      items: [
        { sku: "BK002", productName: "A5 Notebook", category: "Books", quantity: NumberInt(10), unitPrice: NumberDecimal("1500.00") },
        { sku: "AC002", productName: "Water Bottle", category: "Accessories", quantity: NumberInt(2), unitPrice: NumberDecimal("4500.00") }
      ],
      total: { currency: "NGN", amount: NumberDecimal("24000.00") }
    },
    {
      _id: "CM-1008", orderReference: "CM-1008", orderDate: ISODate("2026-10-06T08:15:00.000Z"), status: "cancelled",
      customer: { email: "chidinma@example.test", fullName: "Chidinma Okeke" },
      items: [
        { sku: "EL002", productName: "Wireless Mouse", category: "Electronics", quantity: NumberInt(1), unitPrice: NumberDecimal("8500.00") },
        { sku: "CL001", productName: "Campus T-shirt", category: "Clothing", quantity: NumberInt(1), unitPrice: NumberDecimal("6500.00") }
      ],
      total: { currency: "NGN", amount: NumberDecimal("15000.00") }
    }
  ];

  products.forEach((product) => {
    campusmart.products.replaceOne({ _id: product._id }, product, { upsert: true });
  });

  orders.forEach((order) => {
    campusmart.orders.replaceOne({ _id: order._id }, order, { upsert: true });
  });

  campusmart.products.createIndex(
    { category: 1, stockQuantity: 1 },
    { name: "category_stock_quantity" }
  );
  campusmart.orders.createIndex(
    { "customer.email": 1, orderDate: -1 },
    { name: "customer_email_order_date" }
  );
  campusmart.orders.createIndex(
    { status: 1, orderDate: -1 },
    { name: "status_order_date" }
  );

  print("CampusMart MongoDB seed summary");
  printjson({
    database: campusmart.getName(),
    serverVersion: campusmart.adminCommand({ buildInfo: 1 }).version,
    productDocuments: campusmart.products.countDocuments(),
    orderDocuments: campusmart.orders.countDocuments(),
    embeddedLineItems: orders.reduce((count, order) => count + order.items.length, 0),
    productIndexes: campusmart.products.getIndexes().map((index) => index.name),
    orderIndexes: campusmart.orders.getIndexes().map((index) => index.name)
  });
})();
