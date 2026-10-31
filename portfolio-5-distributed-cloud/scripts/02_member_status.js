const result = db.getSiblingDB("admin").runCommand({ replSetGetStatus: 1 });

if (result.ok !== 1) {
  print("Replica-set status could not be read");
  printjson(result);
  quit(1);
}

print("CampusMart replica-set members");
printjson({
  set: result.set,
  members: result.members.map((member) => ({
    host: member.name,
    state: member.stateStr,
    health: member.health
  }))
});
