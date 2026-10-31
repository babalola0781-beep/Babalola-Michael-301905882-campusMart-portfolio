const campusmart = db.getSiblingDB("campusmart_p5");

const writeResult = campusmart.runCommand({
  update: "orders",
  updates: [
    {
      q: { _id: "P5-CM-1005" },
      u: {
        $set: {
          orderReference: "P5-CM-1005",
          sourcePortfolioOrder: "CM-1005",
          orderDate: ISODate("2026-10-04T10:00:00.000Z"),
          status: "completed",
          customer: {
            email: "amina@example.test",
            fullName: "Amina Yusuf"
          },
          items: [
            {
              sku: "BK001",
              productName: "Database Systems Textbook",
              quantity: NumberInt(1),
              unitPrice: NumberDecimal("16000.00")
            }
          ],
          total: {
            currency: "NGN",
            amount: NumberDecimal("16000.00")
          }
        }
      },
      upsert: true
    }
  ],
  writeConcern: { w: "majority", wtimeout: 15000 }
});

print("Majority-acknowledged order write");
printjson(writeResult);

if (writeResult.ok !== 1 || writeResult.writeConcernError) {
  quit(1);
}

const verification = campusmart.runCommand({
  find: "orders",
  filter: { _id: "P5-CM-1005" },
  readConcern: { level: "majority" }
});

print("Majority-read verification");
printjson(verification.cursor.firstBatch);
