
# opendatacube/datacube-index
Dockerfile for use in indexing into the Open Data Cube

The build images are hosted here: https://hub.docker.com/r/opendatacube/datacube-index.
The Dockerfile is accessible from: https://github.com/opendatacube/datacube-docker/blob/main/index/Dockerfile

`version.txt` file contains the image tag for which the Github action will build and tag the new image.

## How to create a new image with latest odc-tools

To update this image, make any changes you need to `requirements.txt`, then run:

```
pip-compile --upgrade --output-file constraints.txt --strip-extras requirements.txt
```

To minimise version changes, update using the existing image (run from index folder):

```
docker run --rm -v $(pwd):/datacube-index/ -w /datacube-index -it opendatacube/datacube-index bash -c "python3 -m pip install pip-tools && pip-compile --upgrade --output-file constraints.txt --strip-extras requirements.txt"
```



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
