# ER diagram

Open `campusmart-erd.png` or `campusmart-erd.pdf` to view. `campusmart-erd.svg` is
a scalable vector version; `campusmart-erd.drawio` is editable in diagrams.net.

Every field shown exists in `sql/01_schema.sql`. PK,FK on the two ORDER_ITEMS
identifiers means each is a foreign key and together they form the primary key.
Each relationship connects exactly one parent to zero or many child rows.
Draft orders may have no items; requiring items before placement is a later
workflow rule, not a constraint secretly enforced by this diagram.
