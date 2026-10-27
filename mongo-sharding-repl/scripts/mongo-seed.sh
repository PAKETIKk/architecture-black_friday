#!/bin/bash

docker compose exec -T mongos_router mongosh --port 27020 <<EOF
sh.addShard("shard1/shard1-1:27011,shard1-2:27012,shard1-3:27013");
sh.addShard("shard2/shard2-1:27021,shard2-2:27022,shard2-3:27023");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { name: "hashed" });

use somedb
for (var i = 0; i < 1000; i++) {
  db.helloDoc.insertOne({ age: i, name: "ly" + i });
}
exit();
EOF