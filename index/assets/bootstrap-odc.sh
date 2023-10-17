#!/bin/bash
############################################################
# This script allows creation of all metadata/products     #
# in an ODC instance from a given CSV catalog definition   #
# In local development activate <odc> conda environment    #
# In kubernetes pod executor run from <datacube-index>     #
# container                                                #
############################################################
set -o errexit
set -o pipefail
set -o nounset

product_catalog=$1
metadata_catalog=$2

# Workaround for system init bug
#PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOSTNAME" -c 'create schema agdc;' -U "$DB_USERNAME" "$DB_DATABASE"

datacube system init --no-default-types
# Created using : datacube metadata list | awk '{print $1}' | xargs datacube metadata show

# Workaround for system init bug
#PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOSTNAME" -c 'drop view agdc.dv_eo3_dataset ; drop view agdc.dv_eo_dataset ; drop view agdc.dv_telemetry_dataset ; delete from agdc.metadata_type' -U "$DB_USERNAME" "$DB_DATABASE"


datacube metadata add "$metadata_catalog"
dc-sync-products "$product_catalog"

# Clean up
rm product_list.csv
