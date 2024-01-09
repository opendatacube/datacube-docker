FROM ghcr.io/osgeo/gdal:ubuntu-small-3.8.3

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN apt-get update \
    && apt-get upgrade -y \
    # Developer convenience
    && apt-get install -y --no-install-recommends \
        git \
        fish \
        wget \
        unzip \
        # Build tools\
        build-essential \
        python3-pip \
        python3-dev \
        # For Psycopg2
        libpq-dev\
        # Yaml parsing speedup, I think
        libyaml-dev \
        lsb-release \
        # for shapely with --no-binary
        libgeos-dev \
        postgresql-client-14 \
    # Cleanup
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/{apt,dpkg,cache,log}

COPY requirements.txt constraints.txt version.txt /conf/

RUN cat /conf/version.txt \
  && pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir \
    -r /conf/requirements.txt \
    -c /conf/constraints.txt

RUN pip freeze

# Copy Datacube bootstrapping and other scripts
ADD ./assets /code
RUN wget -q https://github.com/opendatacube/datacube-dataset-config/archive/refs/heads/main.zip \
    -O /tmp/datacube-dataset-config.zip \
    && unzip -q /tmp/datacube-dataset-config.zip -d /tmp \
    && cp -r /tmp/datacube-dataset-config-main/odc-product-delete /code/odc-product-delete \
    && rm -r /tmp/datacube-dataset-config-main /tmp/datacube-dataset-config.zip

## Do some symlinking
RUN ln -s /code/bootstrap-odc.sh /usr/local/bin/bootstrap-odc.sh

# Smoke test
RUN s3-to-dc --help
