#!/usr/bin/env bash

set -e
set -o pipefail

odc-stats --version
echo "Checking save tasks"
odc-stats save-tasks --grid africa-20 --year 2019 --overwrite --input-products s2_l2a test-run.db
echo "Checking a job run"
odc-stats run  --threads=1 --plugin pq --location file:///tmp ./test-run.db 0

echo "Test GeoMAD"

odc-stats save-tasks --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/geomedian/ga_ls8c_nbart_gm_cyear_3.yaml --year=2015 --tiles 49:50,24:25 --overwrite geomad-cyear.db
odc-stats run  --threads=1 --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/geomedian/ga_ls8c_nbart_gm_cyear_3.yaml --location file:///tmp --overwrite geomad-cyear.db

./tests/compare_data.sh /tmp/x49/y24/ ga_ls8c_nbart_gm_cyear_3_x49y24_2015--P1Y_final*.tif

echo "Test WO summary"

odc-stats save-tasks --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/wofs_summary/ga_ls_wo_fq_cyear_3.yaml --year=2015 --tiles 49:50,24:25 --overwrite wofs-cyear.db
odc-stats run  --threads=1 --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/wofs_summary/ga_ls_wo_fq_cyear_3.yaml --location file:///tmp --overwrite wofs-cyear.db

./tests/compare_data.sh /tmp/x49/y24/ ga_ls_wo_fq_cyear_3_x49y24_2015--P1Y_fina*.tif

echo "Test FC percentile"

odc-stats save-tasks --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/fc_percentile/ga_ls_fc_pc_cyear_3.yaml --year=2015 --tiles 49:50,24:25 --overwrite fcp-cyear.db
odc-stats run  --threads=1 --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/fc_percentile/ga_ls_fc_pc_cyear_3.yaml --location file:///tmp --overwrite fcp-cyear.db

./tests/compare_data.sh /tmp/x49/y24/ ga_ls_fc_pc_cyear_3_x49y24_2015--P1Y_final*.tif

echo "Test TC percentile"
odc-stats save-tasks --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/tc_percentile/ga_ls_tc_pc_cyear_3.yaml --year=2015 --tiles 49:50,24:25 --overwrite tcp-cyear.db
odc-stats run  --threads=1 --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/tc_percentile/ga_ls_tc_pc_cyear_3.yaml --location file:///tmp --overwrite tcp-cyear.db

./tests/compare_data.sh /tmp/x49/y24/ ga_ls_tc_pc_cyear_3_x49y24_2015--P1Y_final*.tif

# save time without financial year
# test on calendar year seems enough
# not sure if they're needed save for future

# odc-stats save-tasks --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/geomedian/ga_ls8c_nbart_gm_fyear_3.yaml --temporal-range 2014-07--P1Y --tiles 49:50,24:25 --overwrite geomad-fyear.db
# odc-stats run  --threads=1 --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/geomedian/ga_ls8c_nbart_gm_fyear_3.yaml --location file:///tmp --overwrite geomad-fyear.db

# odc-stats save-tasks --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/wofs_summary/ga_ls_wo_fq_fyear_3.yaml --temporal-range 2014-07--P1Y --tiles 49:50,24:25 --overwrite wofs-fyear.db
# odc-stats run  --threads=1 --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/wofs_summary/ga_ls_wo_fq_fyear_3.yaml --location file:///tmp --overwrite wofs-fyear.db

# odc-stats save-tasks --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/fc_percentile/ga_ls_fc_pc_fyear_3.yaml --temporal-range 2014-07--P1Y --tiles 49:50,24:25 --overwrite fcp-fyear.db
# odc-stats run  --threads=1 --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/fc_percentile/ga_ls_fc_pc_fyear_3.yaml --location file:///tmp --overwrite fcp-fyear.db

# odc-stats save-tasks --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/tc_percentile/ga_ls_tc_pc_fyear_3.yaml --temporal-range 2014-07--P1Y --tiles 49:50,24:25 --overwrite tcp-fyear.db
# odc-stats run  --threads=1 --config https://raw.githubusercontent.com/GeoscienceAustralia/dea-config/master/dev/services/odc-stats/tc_percentile/ga_ls_tc_pc_fyear_3.yaml --location file:///tmp --overwrite tcp-fyear.db
