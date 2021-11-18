# opendatacube/datacube-index

Dockerfile for use in indexing into the Open Data Cube

Basic method to update this image is to run:

`pip-compile --extra-index-url https://packages.dea.ga.gov.au/ --output-file constraints.txt requirements.txt`

This will re-generate the constraints.txt file. I believe you need to comment out the `--extra-index-url` line from the
resulting file, but this is far simpler than doing a whole pip build and freeze and then re-testing that build.

I found that pinning the versions of key odc-tools libs in the requirements.txt while running the above
command worked well to upgrade some that were sticky.

# Included commands

## Most commonly used

- `s3-to-dc` A tool for indexing from S3.
- `sqs-to-dc` A tool to index from an SQS queue


the doc for commonly used commands are available here: https://github.com/opendatacube/odc-tools/tree/develop/apps/dc_tools

## Other commands

- `s3-find` list S3 bucket with wildcard
- `s3-to-tar` fetch documents from S3 and dump them to a tar archive
- `gs-to-tar` search GS for documents and dump them to a tar archive
- `dc-index-from-tar` read yaml documents from a tar archive and add them to datacube

description for the above 4 commands are available here: https://github.com/opendatacube/odc-tools#apps
