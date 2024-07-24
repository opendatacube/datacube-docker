#!/usr/bin/env bash

# Echo lines and fail fast
set -ex

docker-compose up -d
docker-compose exec --user ubuntu -T index datacube system init
docker-compose exec --user ubuntu -T index datacube system check
echo "Checking InSAR indexing"
docker-compose exec --user ubuntu -T index datacube product add https://raw.githubusercontent.com/GeoscienceAustralia/digitalearthau/develop/digitalearthau/config/products/cemp_insar_alos_displacement.yaml
docker-compose exec --user ubuntu -T index s3-to-dc --no-sign-request "s3://dea-public-data/cemp_insar/insar/displacement/alos/2010/**/*.yaml" cemp_insar_alos_displacement
echo "Checking Indexed Datasets Count"
docker-compose exec -T postgres psql -U postgres -c "SELECT count(*) from agdc.dataset"
echo "Checking STAC indexing"
docker-compose exec --user ubuntu -T index datacube metadata add https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/38fd6486b151dccd617d5cf973fa6278a2a908e8/product_metadata/eo3_sentinel_ard.odc-type.yaml
docker-compose exec --user ubuntu -T index datacube product add https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/products/baseline_satellite_data/c3/ga_s2am_ard_3.odc-product.yaml
docker-compose exec --user ubuntu -T index s3-to-dc --no-sign-request --skip-lineage --stac "s3://dea-public-data/baseline/ga_s2am_ard_3/55/HFA/2023/02/06/20230206T012949/*.stac-item.json" ga_s2am_ard_3
echo "Checking STAC API indexing"
docker-compose exec --user ubuntu -T index stac-to-dc \
  --catalog-href='https://explorer-aws.dea.ga.gov.au/stac' \
  --limit=1 \
  --collections='ga_s2am_ard_3' \
  --datetime='2023-01-01/2023-01-31'

echo "Checking Indexed Datasets Count (including STAC)"
docker-compose exec -T postgres psql -U postgres -c "SELECT count(*) from agdc.dataset"
docker-compose down
