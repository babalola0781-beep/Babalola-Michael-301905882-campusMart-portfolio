const member = db.adminCommand({ hello: 1 });

if (!member.isWritablePrimary) {
  print("This operation must be run against the current primary.");
  printjson(member);
  quit(2);
}

print("Requesting a planned primary step-down for 180 seconds.");
print("A brief election and write pause may follow.");
printjson(
  db.adminCommand({
    replSetStepDown: 180,
    secondaryCatchUpPeriodSecs: 10
  })
);
