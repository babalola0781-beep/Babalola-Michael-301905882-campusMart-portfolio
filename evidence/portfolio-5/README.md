# Portfolio 5 execution evidence

These screenshots and saved mongosh outputs record the CampusMart replica-set exercise using MongoDB 9.0.4.

The step-down screenshot is from the initial 30-second attempt. The saved final step-down output records the corrected 180-second attempt, and the following status output shows `localhost:27102` as PRIMARY. The evidence index labels the two captures separately.

## Observed results

- Ports 27101, 27102, and 27103 were listening.
- Before step-down, 27101 was PRIMARY; 27102 and 27103 were SECONDARY. All reported health 1.
- The majority write succeeded with `ok: 1`, `n: 1`, and an upserted ID of `P5-CM-1005`.
- The majority-read verification and read from secondary 27102 returned Amina Yusuf's order for BK001, quantity 1, unit price NGN 16,000, total NGN 16,000.
- After the corrected step-down, 27102 was PRIMARY; 27101 and 27103 were SECONDARY, each with health 1.

## Evidence index

| Run result | Script | Screenshot | Saved output |
|---|---|---|---|
| Node ports 27101, 27102, and 27103 listening. | — | [PNG](screenshots/01-node-ports.png) | [TXT](results/01-node-ports.txt) |
| Replica-set initiation and member roles before step-down. | [Initiate](../../portfolio-5-distributed-cloud/scripts/01_initiate_replica_set.js) · [Status](../../portfolio-5-distributed-cloud/scripts/02_member_status.js) | [PNG](screenshots/02-member-status-before.png) | [Initiation](results/02-initiate.txt) · [Status](results/03-member-status-before.txt) |
| Majority-acknowledged order write and verification. | [Write](../../portfolio-5-distributed-cloud/scripts/03_majority_write.js) | [Part A](screenshots/03-majority-write-a.png) · [Part B](screenshots/03-majority-write-b.png) | [TXT](results/04-majority-write.txt) |
| Order returned from secondary 27102 using majority read concern. | [Secondary read](../../portfolio-5-distributed-cloud/scripts/04_secondary_read.js) | [PNG](screenshots/04-secondary-read.png) | [TXT](results/05-secondary-read.txt) |
| Initial 30-second step-down attempt. The final corrected 180-second attempt is recorded in the saved output. | [Step-down](../../portfolio-5-distributed-cloud/scripts/05_stepdown_primary.js) | [Initial attempt](screenshots/05-primary-stepdown-initial-30s.png) | [Final step-down output](results/06-primary-stepdown.txt) |
| Member roles after the corrected step-down. | [Status](../../portfolio-5-distributed-cloud/scripts/02_member_status.js) | [PNG](screenshots/06-member-status-after.png) | [TXT](results/07-member-status-after.txt) |
