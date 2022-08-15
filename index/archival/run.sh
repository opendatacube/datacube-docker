#!/usr/bin/bash

set -eu

for product in $(cat prods.txt); do
    PGPASSWORD=${DB_PASSWORD} psql --no-psqlrc --echo-all --file=query.sql -v product_name=$product -h localhost -U ${DB_USERNAME} -p 5437 odc
done