#!/usr/bin/env bash

docker-compose up -d
docker-compose exec -T index datacube system init
docker-compose exec -T index datacube system check
echo "Checking InSAR indexing"
docker-compose exec -T index datacube product add https://raw.githubusercontent.com/GeoscienceAustralia/digitalearthau/develop/digitalearthau/config/products/cemp_insar_alos_displacement.yaml
docker-compose exec -T index s3-to-dc --no-sign-request "s3://dea-public-data/cemp_insar/insar/displacement/alos/2010/**/*.yaml" cemp_insar_alos_displacement
echo "Checking Indexed Datasets Count"
docker-compose exec -T postgres psql -U postgres -c "SELECT count(*) from agdc.dataset"
echo "Checking STAC indexing"
docker-compose exec -T index datacube product add https://raw.githubusercontent.com/digitalearthafrica/config/master/products/esa_s2_l2a.yaml
docker-compose exec -T index s3-to-dc --no-sign-request --stac "s3://sentinel-cogs/sentinel-s2-l2a-cogs/2020/S2A_32NNF_20200127_0_L2A/*.json" s2_l2a
echo "Checking STAC API indexing"
docker-compose exec -T index stac-to-dc --bbox='5,15,10,20' --limit=10 --collections='sentinel-s2-l2a-cogs' --datetime='2020-08-01/2020-08-31' s2_l2a
echo "Checking Indexed Datasets Count (including STAC)"
docker-compose exec -T postgres psql -U postgres -c "SELECT count(*) from agdc.dataset"
docker-compose down
