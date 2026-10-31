# Portfolio 5: Distributed and Cloud Database Exercise

**Case study:** CampusMart, the same simulated Nigerian online retail business used in Portfolios 1 to 4.

## Exercise design

This activity models CampusMart orders on a three-member MongoDB replica set. The nodes use separate data directories and ports on one Windows computer:

| Member | Address | Initial role |
|---|---|---|
| 0 | localhost:27101 | Preferred primary |
| 1 | localhost:27102 | Secondary |
| 2 | localhost:27103 | Secondary |

All three members are data-bearing voters. The exercise checks member state, records an order with majority write concern, reads that order from a secondary with majority read concern, and requests a controlled primary step-down to observe a new election.

The lab uses localhost only and a separate `campusmart_p5` database. It does not configure authentication or expose MongoDB to the network. The three processes share one computer, so the exercise demonstrates replica-set behavior but cannot demonstrate recovery from a failure of that computer.

## Distributed database concepts

**Replication:** the primary records changes in its operation log and the secondaries replicate those changes. The member-status output shows the current primary and secondary roles.

**Consistency:** the order write requests acknowledgement from a majority of the three data-bearing voters. The secondary-read example uses majority read concern. A secondary can still lag behind the newest primary state, so the example demonstrates a majority-committed read rather than a guarantee that every secondary always has the latest write.

**Availability:** if the primary steps down, eligible secondaries can elect a new primary. Writes can pause briefly during an election. This lab observes that transition; it does not claim uninterrupted service.

**Sharding and cloud deployment:** sharding is not implemented because the CampusMart teaching dataset is small. If the order workload grew, a hashed customer email shard key could distribute customer-specific order histories, while global sales reports would need to read across shards. A production cloud deployment would place replica-set members in separate failure zones, with authentication, TLS, backups, monitoring, and appropriate network controls. No Atlas or other public cloud deployment is claimed here.

## Implementation files

| File | Purpose |
|---|---|
| scripts/01_initiate_replica_set.js | Configures the three-member replica set. |
| scripts/02_member_status.js | Reports the member states and health. |
| scripts/03_majority_write.js | Upserts a CampusMart order with majority write concern and verifies the saved order. |
| scripts/04_secondary_read.js | Reads the order from a secondary using majority read concern. |
| scripts/05_stepdown_primary.js | Requests a controlled step-down of the current primary. |
| references.md | Course brief and MongoDB documentation used for this activity. |
