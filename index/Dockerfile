# syntax=docker/dockerfile:1
FROM ghcr.io/osgeo/gdal:ubuntu-small-3.10.0 AS builder

ARG UV=https://github.com/astral-sh/uv/releases/download/0.5.6/uv-x86_64-unknown-linux-gnu.tar.gz

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=0 \
    UV_PYTHON_DOWNLOADS=never \
    UV_PYTHON=python3.12 \
    UV_PROJECT_ENVIRONMENT=/app

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        unzip \
        # Build tools
        build-essential \
        libffi-dev \
        python3-dev \
        # For Psycopg2
        libpq-dev \
        # Yaml parsing speedup, I think
        libyaml-dev \
        lsb-release \
        # for shapely with --no-binary
        libgeos-dev \
    # Cleanup
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/{apt,dpkg,cache,log}

WORKDIR /build

ADD --checksum=sha256:83521a07922e4ddff61b9204890a974e56ad9333f295690d3ddae931243ec3db --chown=root:root --chmod=644 --link $UV uv.tar.gz

RUN tar xf uv.tar.gz -C /usr/local/bin --strip-components=1 --no-same-owner

COPY --link pyproject.toml version.txt uv.lock /build/

# Use a separate cache volume for uv on opendatacube projects, so it is
# not inseparable from pip/poetry/npm/etc. cache stored in /root/.cache.
RUN --mount=type=cache,id=opendatacube-uv-cache,target=/root/.cache \
    uv sync --locked --no-dev --no-install-project \
      --no-binary-package fiona \
      --no-binary-package rasterio \
      --no-binary-package shapely

FROM ghcr.io/osgeo/gdal:ubuntu-small-3.10.0

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    PATH=/app/bin:$PATH \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        unzip \
        # For Psycopg2
        libpq5 \
        lsb-release \
        postgresql-client-16 \
    # Cleanup
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/{apt,dpkg,cache,log}

WORKDIR /conf

COPY --from=builder --link --chown=ubuntu:ubuntu /app /app
COPY --from=builder --link /build/*.txt /conf/

# Copy Datacube bootstrapping and other scripts
COPY --link ./assets /code
RUN curl -L -fsS https://github.com/opendatacube/datacube-dataset-config/archive/refs/heads/main.zip \
    -o /tmp/datacube-dataset-config.zip \
    && unzip -q /tmp/datacube-dataset-config.zip -d /tmp \
    && cp -r /tmp/datacube-dataset-config-main/odc-product-delete /code/odc-product-delete \
    && rm -r /tmp/datacube-dataset-config-main /tmp/datacube-dataset-config.zip \
    && ln -s /code/bootstrap-odc.sh /usr/local/bin/bootstrap-odc.sh \
    && cat /conf/version.txt

# Smoke test
RUN s3-to-dc --help
