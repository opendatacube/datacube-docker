
# opendatacube/datacube-index
Dockerfile for use in indexing into the Open Data Cube

The build images are hosted here: https://hub.docker.com/r/opendatacube/datacube-index.
The Dockerfile is accessible from: https://github.com/opendatacube/datacube-docker/blob/main/index/Dockerfile

`version.txt` file contains the image tag for which the Github action will build and tag the new image.

## How to create a new image with latest odc-tools

Basic method to update this image is to run:

```
rm constraints.txt
pip-compile --extra-index-url https://packages.dea.ga.gov.au/ --pre --output-file constraints.txt requirements.txt
```

The flag `--pre` will create `constraints.txt` with the latest available package. i.e.

```
odc-apps-cloud==0.2.2.dev3367
    # via -r requirements.txt
odc-apps-dc-tools==0.2.5.dev3367
    # via -r requirements.txt
odc-cloud[async]==0.2.2.dev3367
    # via
    #   odc-apps-cloud
    #   odc-apps-dc-tools
odc-io==0.2.2.dev3367
    # via
    #   odc-apps-cloud
    #   odc-apps-dc-tools
```
If building the image with `.dev` latest libraries *DO NOT* edit the `version.txt` file, the new image will be tagged in the format i.e. `0.1.6.dev1212121`
## How to create a new image with tagged released libraries

```
rm constraints.txt
pip-compile --extra-index-url https://packages.dea.ga.gov.au/ --output-file constraints.txt requirements.txt`
```

This will re-generate the constraints.txt file with comments. Check for library version do not contain `.dev`

```
odc-apps-cloud==0.2.1
    # via -r requirements.txt
odc-apps-dc-tools==0.2.4
    # via -r requirements.txt
odc-cloud[async]==0.2.1
```

Edit `version.txt` to create an incremented tagged image number.
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
