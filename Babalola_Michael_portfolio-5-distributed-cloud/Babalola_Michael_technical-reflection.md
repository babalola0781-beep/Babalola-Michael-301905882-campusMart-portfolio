# Portfolio 5 technical reflection

## Replication

Before the planned step-down, my status output showed `localhost:27101` as PRIMARY and `localhost:27102` and `localhost:27103` as SECONDARY. After the corrected 180-second step-down, the status output showed `localhost:27102` as PRIMARY; the other two members were SECONDARY. All three members showed health 1.

## Consistency

The majority-write output returned `ok: 1` and `n: 1`, with an upserted document ID of `P5-CM-1005`. The majority-read verification and the read from secondary `localhost:27102` both returned that CampusMart order: Amina Yusuf's completed order for one BK001 Database Systems Textbook, at NGN 16,000.

## Availability

The planned step-down command returned `ok: 1`. The after-status output showed that `localhost:27102` had become PRIMARY. My saved output does not show a connection-change message or measure the length of a write pause, so I can confirm that the election completed but cannot report an observed interruption duration.

## Limitation

All three MongoDB members ran on one computer. They shared its operating system, power, storage, and network connection. If that computer failed, all three members could become unavailable together. This run demonstrates replica-set behavior on one machine; it does not demonstrate recovery from a computer or site failure.
