FROM osgeo/gdal:ubuntu-small-3.3.2

ARG BUILD_DATE
ARG VCS_REF
ARG STATS_VERSION

# Labels.
# See https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.title="opendatacube/statistician"
LABEL org.opencontainers.image.description="Open Datacube Statistician"
LABEL org.opencontainers.image.url="https://opendatacube.org/"
LABEL org.opencontainers.image.source="https://github.com/opendatacube/datacube-docker/tree/main/statistician"
LABEL org.opencontainers.image.version=$VCS_REF
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.vendor="Geoscience Australia"
label org.opendatacube.stats-version=$STATS_VERSION
#LABEL org.opencontainers.image.version=$BUILD_VERSION
LABEL org.opencontainers.image.documentation="https://github.com/opendatacube/odc-tools/tree/develop/libs/stats/"


ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN apt-get update \
    && apt-get install -y \
    # Build tools\
    build-essential \
    python3-pip \
    python3-dev \
    # For Psycopg2
    libpq-dev\
    postgresql-client-12 \
    # Developer convenience
    git \
    wget \
    unzip \
    htop \
    tmux \
    vi \
    # Yaml parsing speedup, I think
    libyaml-dev \
    # Cleanup
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -vrf /var/lib/apt/lists/*
#    && rm -vrf /var/lib/{apt,dpkg,cache,log}


# Add in the dask configuration
COPY distributed.yaml /etc/dask/distributed.yaml


COPY requirements.txt constraints.txt version.txt /conf/

RUN cat /conf/version.txt \
  && pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir \
    -r /conf/requirements.txt \
    -c /conf/constraints.txt

RUN pip freeze


WORKDIR /tmp


RUN odc-stats --help
