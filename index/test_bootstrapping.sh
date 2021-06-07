#!/usr/bin/env bash

# Echo lines and fail fast
set -ex

docker-compose up -d
docker-compose run index bash -c "cd \$HOME && /code/bootstrap-odc.sh \$PRODUCT_CATALOG \$METADATA_CATALOG"
docker-compose exec -T postgres psql -U postgres -c "SELECT count(*) from agdc.metadata_type"
docker-compose exec -T postgres psql -U postgres -c "SELECT count(*) from agdc.dataset_type"
docker-compose down
