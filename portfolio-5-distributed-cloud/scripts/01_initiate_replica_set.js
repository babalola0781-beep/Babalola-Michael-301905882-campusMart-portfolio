const config = {
  _id: "rsCampusMart",
  members: [
    { _id: 0, host: "localhost:27101", priority: 2 },
    { _id: 1, host: "localhost:27102" },
    { _id: 2, host: "localhost:27103" }
  ]
};

print("Initiating the CampusMart replica set");
printjson(db.getSiblingDB("admin").runCommand({ replSetInitiate: config }));
