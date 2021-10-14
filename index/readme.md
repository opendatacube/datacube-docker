# opendatacube/datacube-index

Dockerfile for use in indexing into the Open Data Cube

Basic method to update this image is to run:

`pip-compile --extra-index-url https://packages.dea.ga.gov.au/ --output-file constraints.txt requirements.txt`

This will re-generate the constraints.txt file. I believe you need to comment out the `--extra-index-url` line from the
resulting file, but this is far simpler than doing a whole pip build and freeze and then re-testing that build.

I found that pinning the versions of key odc-tools libs in the requirements.txt while running the above
command worked well to upgrade some that were sticky.
