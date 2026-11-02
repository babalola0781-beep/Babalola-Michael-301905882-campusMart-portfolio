const admin = db.getSiblingDB("admin");
const member = admin.runCommand({ hello: 1 });

print("Connected replica-set member");
printjson({
  member: member.me,
  isWritablePrimary: member.isWritablePrimary,
  secondary: member.secondary
});

const orders = db.getSiblingDB("campusmart_p5").orders;
const cursor = orders
  .find({ _id: "P5-CM-1005" })
  .readPref("secondary")
  .readConcern("majority");

print("Order read using secondary preference and majority read concern");
printjson(cursor.toArray());
