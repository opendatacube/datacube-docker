#!/usr/bin/env bash
set -ex

docker-compose up -d
sleep 5

docker-compose exec -T stats odc-stats --help
echo "Indexing some data"
docker-compose exec -T stats datacube system init
docker-compose exec -T stats datacube system check
docker-compose exec -T stats datacube product add https://raw.githubusercontent.com/digitalearthafrica/config/master/products/esa_s2_l2a.odc-product.yaml
docker-compose exec -T stats stac-to-dc --bbox='4,5,5,6' --collections='sentinel-s2-l2a-cogs' --datetime='2019-09-01/2020-01-01' s2_l2a
echo "Checking save tasks"
docker-compose exec -T stats odc-stats save-tasks --grid africa-20 --year 2019 --overwrite s2_l2a test-run.db
echo "Checking a job run"
docker-compose exec -T stats odc-stats run --plugin pq --location file:///tmp ./test-run.db 0
docker-compose exec -T stats ls /tmp
