#!/usr/bin/env bash
set -ex

docker-compose up -d
sleep 5

docker-compose exec -T stats odc-stats --help
echo "Indexing some data"
docker-compose exec -T stats datacube system init
docker-compose exec -T stats datacube system check
docker-compose exec -T stats datacube product add https://raw.githubusercontent.com/digitalearthafrica/config/master/products/esa_s2_l2a.odc-product.yaml
docker-compose exec -T stats stac-to-dc --bbox='4,5,5,6' --collections='sentinel-s2-l2a-cogs' --datetime='2019-09-01/2020-01-01' --limit 1000
echo "Checking save tasks"
docker-compose exec -T stats odc-stats save-tasks --grid africa-20 --year 2019 --overwrite s2_l2a test-run.db
echo "Checking a job run"
docker-compose exec -T stats odc-stats run  --threads=1 --plugin pq --location file:///tmp ./test-run.db 0
docker-compose exec -T stats ls /tmp

# add eodatasets3 + OWS integration test

# 1) GeoMAD-AU
docker-compose exec -T stats datacube metadata add https://raw.githubusercontent.com/GeoscienceAustralia/digitalearthau/develop/digitalearthau/config/eo3/eo3_landsat_ard.odc-type.yaml
docker-compose exec -T stats datacube product add https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/products/baseline_satellite_data/c3/ard_ls8.odc-product.yaml

# only index several data to speed up yearly summary run
docker-compose exec -T stats s3-to-dc "s3://dea-public-data/baseline/ga_ls8c_ard_3/088/079/2015/02/*/*.json" --no-sign-request --skip-lineage --stac ga_ls8c_ard_3
docker-compose exec -T stats s3-to-dc "s3://dea-public-data/baseline/ga_ls8c_ard_3/088/079/2015/03/*/*.json" --no-sign-request --skip-lineage --stac ga_ls8c_ard_3
docker-compose exec -T stats s3-to-dc "s3://dea-public-data/baseline/ga_ls8c_ard_3/088/079/2015/04/*/*.json" --no-sign-request --skip-lineage --stac ga_ls8c_ard_3
docker-compose exec -T stats s3-to-dc "s3://dea-public-data/baseline/ga_ls8c_ard_3/088/079/2015/05/*/*.json" --no-sign-request --skip-lineage --stac ga_ls8c_ard_3

echo "Checking EODatasets3 integration save tasks"
docker-compose exec -T stats odc-stats save-tasks --grid=au-10 --year=2015 --overwrite ga_ls8c_ard_3 eo3-test-run.db
echo "Checking EODatasets3 integration job run"

# wget the odc-stats run cfg from Github: https://github.com/GeoscienceAustralia/dea-config/blob/master/dev/services/odc-stats/geomedian/ga_ls8c_nbart_gm_cyear_3.yaml
docker-compose exec -T stats wget https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/geomedian/ga_ls8c_nbart_gm_cyear_3.yaml
docker-compose exec -T stats odc-stats run  --threads=1 --config ga_ls8c_nbart_gm_cyear_3.yaml --resolution=30 --location file:///tmp ./eo3-test-run.db 0 --apply_eodatasets3
docker-compose exec -T stats ls /tmp

# 2) WO-summary-AU

docker-compose down