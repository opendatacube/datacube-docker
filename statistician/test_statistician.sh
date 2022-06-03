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

# add eodatasets3 + OWS integration test

# 1) GeoMAD-AU
docker-compose exec -T stats datacube metadata add https://raw.githubusercontent.com/GeoscienceAustralia/digitalearthau/develop/digitalearthau/config/eo3/eo3_landsat_ard.odc-type.yaml
docker-compose exec -T stats datacube product add https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/products/baseline_satellite_data/c3/ga_ls8c_ard_3.odc-product.yaml

# only index several data to speed up yearly summary run
docker-compose exec -e AWS_DEFAULT_REGION=ap-southeast-2 -T stats s3-to-dc "s3://dea-public-data/baseline/ga_ls8c_ard_3/088/079/2015/02/*/*.json" --no-sign-request --skip-lineage --stac ga_ls8c_ard_3
docker-compose exec -e AWS_DEFAULT_REGION=ap-southeast-2 -T stats s3-to-dc "s3://dea-public-data/baseline/ga_ls8c_ard_3/088/079/2015/03/*/*.json" --no-sign-request --skip-lineage --stac ga_ls8c_ard_3
docker-compose exec -e AWS_DEFAULT_REGION=ap-southeast-2 -T stats s3-to-dc "s3://dea-public-data/baseline/ga_ls8c_ard_3/088/079/2015/04/*/*.json" --no-sign-request --skip-lineage --stac ga_ls8c_ard_3
docker-compose exec -e AWS_DEFAULT_REGION=ap-southeast-2 -T stats s3-to-dc "s3://dea-public-data/baseline/ga_ls8c_ard_3/088/079/2015/05/*/*.json" --no-sign-request --skip-lineage --stac ga_ls8c_ard_3

echo "Checking GeoMAD EODatasets3 integration save tasks"
docker-compose exec -T stats odc-stats save-tasks --grid=au-10 --year=2015 --overwrite ga_ls8c_ard_3 geomad-eo3-test-run.db

echo "Checking GeoMAD EODatasets3 integration job run"
# wget the odc-stats run cfg from Github: https://github.com/GeoscienceAustralia/dea-config/blob/master/dev/services/odc-stats/geomedian/ga_ls8c_nbart_gm_cyear_3.yaml
docker-compose exec -T stats wget https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/geomedian/ga_ls8c_nbart_gm_cyear_3.yaml
docker-compose exec -T stats odc-stats run  --threads=1 --config ga_ls8c_nbart_gm_cyear_3.yaml --resolution=30 --location file:///tmp geomad-eo3-test-run.db 0 --overwrite --apply_eodatasets3

# 2) WO-summary-AU
docker-compose exec -T stats datacube product add https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/products/inland_water/c3_wo/ga_ls_wo_3.odc-product.yaml

# only index several data to speed up yearly summary run
docker-compose exec -e AWS_DEFAULT_REGION=ap-southeast-2 -T stats s3-to-dc "s3://dea-public-data/derivative/ga_ls_wo_3/1-6-0/088/079/2015/02/*/*.json" --no-sign-request --skip-lineage --stac ga_ls_wo_3
docker-compose exec -e AWS_DEFAULT_REGION=ap-southeast-2 -T stats s3-to-dc "s3://dea-public-data/derivative/ga_ls_wo_3/1-6-0/088/079/2015/03/*/*.json" --no-sign-request --skip-lineage --stac ga_ls_wo_3
docker-compose exec -e AWS_DEFAULT_REGION=ap-southeast-2 -T stats s3-to-dc "s3://dea-public-data/derivative/ga_ls_wo_3/1-6-0/088/079/2015/04/*/*.json" --no-sign-request --skip-lineage --stac ga_ls_wo_3
docker-compose exec -e AWS_DEFAULT_REGION=ap-southeast-2 -T stats s3-to-dc "s3://dea-public-data/derivative/ga_ls_wo_3/1-6-0/088/079/2015/05/*/*.json" --no-sign-request --skip-lineage --stac ga_ls_wo_3

echo "Checking WO summary EODatasets3 integration save tasks"
docker-compose exec -T stats odc-stats save-tasks --grid=au-30 --year=2015 --overwrite ga_ls_wo_3 wo-summary-eo3-test-run.db

echo "Checking WO summary EODatasets3 integration job run"
docker-compose exec -T stats wget https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/wofs_summary/ga_ls_wo_fq_cyear_3.yaml
docker-compose exec -T stats odc-stats run  --threads=1 --config ga_ls_wo_fq_cyear_3.yaml --resolution=30 --location file:///tmp wo-summary-eo3-test-run.db 0 --overwrite --apply_eodatasets3

# 3) FCP-AU
docker-compose exec -T stats datacube product add https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/products/land_and_vegetation/c3_fc/ga_ls_fc_3.odc-product.yaml

# only index several data to speed up yearly summary run
docker-compose exec -e AWS_DEFAULT_REGION=ap-southeast-2 -T stats s3-to-dc "s3://dea-public-data/derivative/ga_ls_fc_3/2-5-1/088/079/2015/02/*/*.json" --no-sign-request --skip-lineage --stac ga_ls_fc_3
docker-compose exec -e AWS_DEFAULT_REGION=ap-southeast-2 -T stats s3-to-dc "s3://dea-public-data/derivative/ga_ls_fc_3/2-5-1/088/079/2015/03/*/*.json" --no-sign-request --skip-lineage --stac ga_ls_fc_3
docker-compose exec -e AWS_DEFAULT_REGION=ap-southeast-2 -T stats s3-to-dc "s3://dea-public-data/derivative/ga_ls_fc_3/2-5-1/088/079/2015/04/*/*.json" --no-sign-request --skip-lineage --stac ga_ls_fc_3
docker-compose exec -e AWS_DEFAULT_REGION=ap-southeast-2 -T stats s3-to-dc "s3://dea-public-data/derivative/ga_ls_fc_3/2-5-1/088/079/2015/05/*/*.json" --no-sign-request --skip-lineage --stac ga_ls_fc_3

echo "Checking WO summary EODatasets3 integration save tasks"
docker-compose exec -T stats odc-stats save-tasks --grid=au-30 --year=2015 --overwrite ga_ls_fc_3+ga_ls_wo_3 fcp-eo3-test-run.db

echo "Checking WO summary EODatasets3 integration job run"
docker-compose exec -T stats wget https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/fc_percentile/ga_ls_fc_pc_cyear_3.yaml
docker-compose exec -T stats odc-stats run  --threads=1 --config ga_ls_fc_pc_cyear_3.yaml --resolution=30 --location file:///tmp fcp-eo3-test-run.db 0 --overwrite --apply_eodatasets3

docker-compose exec -T stats ls -R /tmp
